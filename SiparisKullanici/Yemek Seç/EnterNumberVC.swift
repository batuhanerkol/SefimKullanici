//
//  EnterNumberVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalTableNumberEnterNumberVC: String = ""
var globalBusinessNameEnterNumberVC = ""

class EnterNumberVC: UIViewController {
    
      var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
  
    var nameArray = [String]()
    var kontroArray = [String]()
    var kontrolMasaNoArray = [String]()
    var totalPriceArray = [String]()
    var hesapOdendi = ""
    var masaSayisi = ""
    
    @IBOutlet weak var enterNumberButton: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //inbternet kontrol
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUserInterface()
    }
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            let alert = UIAlertController(title: "İnternet Bağlantınız Bulunmuyor.", message: "Lütfen Kontrol Edin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            self.enterNumberButton.isEnabled = false
        case .wifi:
            getBussinessNameData()
            self.enterNumberButton.isEnabled = true
            
        case .wwan:
            getBussinessNameData()
            self.enterNumberButton.isEnabled = true
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
  
    func getBussinessNameData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessUserName", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                for object in objects!{
                  
                    
                    self.businessNameLabel.text = (object.object(forKey: "businessName") as! String)
                    globalBusinessNameEnterNumberVC = (object.object(forKey: "businessName") as! String)
                    self.masaSayisi = (object.object(forKey: "MasaSayisi") as! String)
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

    @IBAction func OKButtonPressed(_ sender: Any) {
        
        if numberTextField.text != ""{
            if Int(numberTextField.text!)! <= Int(self.masaSayisi)!{
            
            globalTableNumberEnterNumberVC = self.numberTextField.text!
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let query = PFQuery(className: "VerilenSiparisler")
            query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
            query.addDescendingOrder("createdAt")
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else{
                    self.kontroArray.removeAll(keepingCapacity: false)
                    self.kontrolMasaNoArray.removeAll(keepingCapacity: false)
                    self.totalPriceArray.removeAll(keepingCapacity: false)
                    self.hesapOdendi = ""
                    
                    for object in objects!{
                        
                        self.kontroArray.append(object.object(forKey: "IsletmeAdi") as! String)
                         self.kontrolMasaNoArray.append(object.object(forKey: "MasaNo") as! String)
                        self.hesapOdendi = (object.object(forKey: "HesapOdendi") as! String)
                        self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)
                        
                        
                    }
                    print("self.kontroArray", self.kontroArray)
                    print("kontrolMasaNo", self.kontrolMasaNoArray)
                    print("hesapOdendi", self.hesapOdendi)
                    
                    if self.kontroArray.isEmpty == true && self.kontrolMasaNoArray.isEmpty == true && self.hesapOdendi == ""{
                   
                        
                        self.performSegue(withIdentifier: "enterNumberToSelectFood", sender: nil)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    else if self.kontroArray.last! == self.businessNameLabel.text! && self.kontrolMasaNoArray.last! == self.numberTextField.text!{
                        
                     
                        self.performSegue(withIdentifier: "enterNumberToSelectFood", sender: nil)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    else if self.kontroArray.last! != "" && self.kontrolMasaNoArray.last! != "" && self.hesapOdendi == "Evet"{
                        self.performSegue(withIdentifier: "enterNumberToSelectFood", sender: nil)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    else{
                        
                        let alert = UIAlertController(title: "\(self.kontroArray.last!) İsimli İşletmede, \(self.kontrolMasaNoArray.last!) Numaralı Masa da, \(self.totalPriceArray.last!) ₺ Tutarında, Ödenmemiş Hesabınız Bulunmakta", message: "Lütfen İlgili Personele Bildirin", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }

        }else{
            let alert = UIAlertController(title: "İşletme de Bulunan Masa Sayisi: \(self.masaSayisi)", message: "Lütfen Mevcut Bir Masa Sayısı Girin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        }else{
            let alert = UIAlertController(title: "Lütfen Masa Numaranızı Girin", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
