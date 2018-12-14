//
//  MusteriBilgileriVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class MusteriBilgileriVC: UIViewController, UITextFieldDelegate {
    
    var nameArray = [String]()
    var surnameArray = [String]()
    var userNameArray = [String]()
    var phoneNumberArray = [String]()
    var emailArray = [String]()

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var phoneNoText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
         saveChangesButton.isHidden = true
        
    
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            let alert = UIAlertController(title: "İnternet Bağlantınız Bulunmuyor.", message: "Lütfen Kontrol Edin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
             self.saveChangesButton.isEnabled = false
            
        case .wifi:
            getUserInfoFromParse()
            whenTextFiledsChange()
           self.saveChangesButton.isEnabled = true
            
            
        case .wwan:
            getUserInfoFromParse()
            whenTextFiledsChange()
             self.saveChangesButton.isEnabled = true
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveChangesButton.isHidden = false
    }
    func whenTextFiledsChange(){
        emailText.addTarget(self, action: #selector(MusteriBilgileriVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        nameText.addTarget(self, action: #selector(MusteriBilgileriVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surnameText.addTarget(self, action: #selector(MusteriBilgileriVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        phoneNoText.addTarget(self, action: #selector(MusteriBilgileriVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
   
    func getUserInfoFromParse(){
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: "\(PFUser.current()!.username!)")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                self.surnameArray.removeAll(keepingCapacity: false)
                self.userNameArray.removeAll(keepingCapacity: false)
                self.phoneNumberArray.removeAll(keepingCapacity: false)
                self.emailArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    self.nameArray.append(object.object(forKey: "name") as! String)
                    self.surnameArray.append(object.object(forKey: "lastname") as! String)
                    self.userNameArray.append(object.object(forKey: "username") as! String)
                    self.phoneNumberArray.append(object.object(forKey: "PhoneNumber") as! String)
                    self.emailArray.append(object.object(forKey: "email") as! String)
                    
                    self.nameText.text = "\(self.nameArray.last!)"
                    self.surnameText.text = "\(self.surnameArray.last!)"
                    self.userNameLabel.text = "\(self.userNameArray.last!)"
                    self.phoneNoText.text = "\(self.phoneNumberArray.last!)"
                    self.emailText.text = "\(self.emailArray.last!)"
                    
                }
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        let currentId = PFUser.current()?.objectId!
        let query = PFQuery(className: "_User")
        
        query.getObjectInBackground(withId: currentId!) { (object, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                if self.nameText.text! != "" && self.surnameText.text! != "" && self.phoneNoText.text! != "" && self.emailText.text! != ""{
                object!["name"] = self.nameText.text!
                object!["lastname"] = self.surnameText.text!
                object!["PhoneNumber"] = self.phoneNoText.text!
                object!["email"] = self.emailText.text!
                object?.saveInBackground()
                
                let alert = UIAlertController(title: "Değişiklikler Kayıt Edildi", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                    
                    
                
                self.saveChangesButton.isHidden = true
                }else{
                    let alert = UIAlertController(title: "Lütfen Boş Kalmış Bilgilerinizi Giriniz", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
 
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
