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
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextfield.delegate = self
        self.passwordtextField.delegate = self
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
      
        if usernameTextfield.text != "" && passwordtextField.text != ""{
            
            PFUser.logInWithUsername(inBackground: self.usernameTextfield.text!, password: self.passwordtextField.text!) { (user, error) in
                
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                }
                else{
                    
                    
                    UserDefaults.standard.set(self.usernameTextfield.text!, forKey: "userName")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
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
