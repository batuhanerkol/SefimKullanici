//
//  EnterNumberVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class EnterNumberVC: UIViewController {

    var nameArray = [String]()
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBussinessNameData()
    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "Locations")
        query.whereKey("businessLocationOwner", equalTo: globalStringValue)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.nameArray.append(object.object(forKey: "businessName") as! String)
                    
                    self.businessNameLabel.text = "\(self.nameArray.last!)"
                }
            }
        }
    }

    @IBAction func OKButtonPressed(_ sender: Any) {
    }
    
}
