//
//  ChangePasswordVC.swift
//  
//
//  Created by Batuhan Erkol on 21.10.2018.
//

import UIKit
import Parse
class ChangePasswordVC: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var newPasswordAgainTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
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
            
             self.saveButton.isEnabled = false
            
        case .wifi:
        self.saveButton.isEnabled = true
            
            
        case .wwan:
             self.saveButton.isEnabled = true
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let currentId = PFUser.current()?.objectId!
        let query = PFQuery(className: "_User")
        
        query.getObjectInBackground(withId: currentId!) { (object, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if self.oldPasswordTextField.text! != PFUser.current()?.password{
                    if self.newPasswordTextField.text! == self.newPasswordAgainTextField.text{
                        object!["password"] = self.newPasswordAgainTextField.text!
                        object?.saveInBackground()
                        let alert = UIAlertController(title: "Şifre Başarıyla Değiştirildi", message: "", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Yeni Şifre Eşleşmiyor", message: "", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    let alert = UIAlertController(title: "Eski Şifre Hatalı", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    }
    

