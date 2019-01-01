//
//  StartVerificationViewController.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 18.12.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

var globalPhoneNumberStartVerification = ""
class StartVerificationViewController: UIViewController {
    
    @IBOutlet var phoneNumberField: UITextField! = UITextField()
    @IBOutlet var countryCodeField: UITextField! = UITextField()
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNumberField.text,
            let countryCode = countryCodeField.text {
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
            
            globalPhoneNumberStartVerification = phoneNumberField.text!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CheckVerificationViewController {
            dest.countryCode = countryCodeField.text
            dest.phoneNumber = phoneNumberField.text
        }
    }
}
