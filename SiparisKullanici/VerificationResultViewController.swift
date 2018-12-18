//
//  VerificationResultViewController.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 18.12.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

class VerificationResultViewController: UIViewController {
    
    @IBOutlet var successIndication: UILabel! = UILabel()
    
    var message: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = message {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
}
