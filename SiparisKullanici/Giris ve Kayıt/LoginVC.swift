//
//  LoginVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 12.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextfield.delegate = self
        self.passwordtextField.delegate = self
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
      
        if usernameTextfield.text != "" && passwordtextField.text != ""{
            
            PFUser.logInWithUsername(inBackground: self.usernameTextfield.text!, password: self.passwordtextField.text!) { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    
                    print("GİRİŞ YAPILDI")
                    self.performSegue(withIdentifier: "loginToTanBar", sender: nil)
                    
                    UserDefaults.standard.set(self.usernameTextfield.text!, forKey: "userLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            }
        }
        else{
            let alert = UIAlertController(title: "HATA", message: "Kullanıcı Adı veya Şifre Eksik", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        dismissKeyboard()
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    

}
