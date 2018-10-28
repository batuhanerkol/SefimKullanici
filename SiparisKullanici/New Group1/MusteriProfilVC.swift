//
//  MusteriProfilVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 13.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class MusteriProfilVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                UserDefaults.standard.removeObject(forKey: "userLoggedIn")
                UserDefaults.standard.synchronize()
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = loginVC
                delegate.rememberUser()
                
            }
        }
        
    }
    
}
