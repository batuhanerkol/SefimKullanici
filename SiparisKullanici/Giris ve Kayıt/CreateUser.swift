//
//  CreateUser.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 12.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class CreateUser: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordAgaintextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.nameTextField.delegate = self
         self.lastNameTextField.delegate = self
         self.emailTextField.delegate = self
         self.passwordTextField.delegate = self
         self.passwordAgaintextField.delegate = self
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func signUpbuttonClicked(_ sender: Any) {
        
        
        let email = isValidEmail(testStr: emailTextField.text!)
        if email == true {

            if  emailTextField.text != "" && nameTextField.text != "" && lastNameTextField.text != "" && passwordTextField.text != "" {
                
                if passwordTextField.text == passwordAgaintextField.text {

                let userSignUp = PFUser()
                userSignUp.username = emailTextField.text!
                userSignUp.password = passwordTextField.text!
                userSignUp["PhoneNumber"] = globalPhoneNumberStartVerification
                userSignUp.email = emailTextField.text!
                userSignUp["name"] = nameTextField.text!
                userSignUp["lastname"] = lastNameTextField.text!
                userSignUp["UyelikTipi"] = ("Musteri")


                userSignUp.signUpInBackground { (success, error) in

                    if error != nil{
                        let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }



                    else{
                     
                        
                        UserDefaults.standard.set(self.emailTextField.text!, forKey: "userName")
                        UserDefaults.standard.synchronize()
                        
                        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.rememberUser()
                        
                        
                        print("kullanıcı oluşturuldu")
                        self.performSegue(withIdentifier: "createUserToTabbar", sender: nil)

                       
                        
                   
                    }
                    
                    }
                }else{
                    let alert = UIAlertController(title: "HATA", message: "Şifreler Eşleşmiyor", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "HATA", message: "Lütfen Bütün Bilgileri Giriniz", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }

        else{

            let alert = UIAlertController(title: "HATA", message: "Bir E-mail Giriniz", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    
    func login(){
        
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: self.passwordAgaintextField.text!) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                print("Login yapıldı")
            }
        }
    }
    }


