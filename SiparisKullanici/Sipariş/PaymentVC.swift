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
    
    
    @IBOutlet weak var payCreditCardButton: UIButton!
    @IBOutlet weak var payCashButton: UIButton!
    
    var date = ""
    var time = ""
    var objectId = ""
    var objectIdArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
          updateUserInterface()

        payCashButton.isEnabled = false
        payCreditCardButton.isEnabled = false
  
        
        
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
            self.payCreditCardButton.isEnabled = false
            self.payCashButton.isEnabled = false
            
        case .wifi:
            
            getDateTimeForPayment()
            self.payCreditCardButton.isEnabled = true
            self.payCashButton.isEnabled = true
        case .wwan:
           getDateTimeForPayment()
           self.payCreditCardButton.isEnabled = true
           self.payCashButton.isEnabled = true
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func getDateTimeForPayment(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("MasaNo", equalTo: globalTableNumberEnterNumberVC)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessNameEnterNumberVC)
        query.whereKey("HesapOdendi", notEqualTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.dateArray.removeAll(keepingCapacity: false)
                self.time.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                  
                    self.dateArray.append(object.object(forKey: "Date") as! String)
                    self.timeArray.append(object.object(forKey: "Time") as! String)
                    
                    self.date = "\(self.dateArray.last!)"
                    self.time = "\(self.timeArray.last!)"
                }

                print(self.date)
                print(self.time)
                self.getObjectId()
                
               
            }
            
        }
    }
    func getObjectId(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessNameEnterNumberVC)
        query.whereKey("Date", equalTo: date) //siparişi verdiğim anın tarihi
        query.whereKey("Time", equalTo: time)
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
                    self.objectIdArray.append(object.objectId! )
                    
                    self.objectId = "\(self.objectIdArray.last!)"
                }
                    print("objectId:",self.objectId)
                self.payCashButton.isEnabled = true
                self.payCreditCardButton.isEnabled = true
            }
        }
    }
    @IBAction func payCashButtonClicked(_ sender: Any) {
        if objectIdArray.isEmpty == false{
        let query = PFQuery(className: "VerilenSiparisler")

        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
            
                objects!["HesapIstendi"] = "Nakit"
                objects!.saveInBackground()
                
                let alert = UIAlertController(title: "Hesap Birazdan Size Ulaştırılacaktır", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
    }
    
    @IBAction func payCreditCardButtonPressed(_ sender: Any) {
        if objectIdArray.isEmpty == false{
        let query = PFQuery(className: "VerilenSiparisler")
  
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {

                objects!["HesapIstendi"] = "KrediKarti"
                objects!.saveInBackground()
                
                let alert = UIAlertController(title: "Hesap Birazdan Size Ulaştırılacaktır", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
    }
    
}
