//
//  PaymentVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 10.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class PaymentVC: UIViewController {
    
    var objectId = ""
    var objectIdArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getObjectId()
    }
    func getObjectId(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessName)
        query.whereKey("Date", equalTo: globalDateForPayment)
        query.whereKey("Time", equalTo: globalTimeForPayment)
        query.whereKey("HesapOdendi", notEqualTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.objectIdArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.objectIdArray.append(object.objectId as! String)
                    
                    self.objectId = "\(self.objectIdArray.last!)"
                }
            }
        }
    }
    @IBAction func payCashButtonClicked(_ sender: Any) {
        let query = PFQuery(className: "VerilenSiparisler")

        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                print(self.objectId)
                objects!["HesapIstendi"] = "Nakit"
                objects!.saveInBackground()
            }
        }

    }
    
    @IBAction func payCreditCardButtonPressed(_ sender: Any) {
        let query = PFQuery(className: "VerilenSiparisler")
  
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                print(self.objectId)
                objects!["HesapIstendi"] = "KrediKarti"
                objects!.saveInBackground()
            }
        }

    }
    
}
