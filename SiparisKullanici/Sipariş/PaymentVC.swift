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
    var yemekTeslimEdildiArray = [String]()
    var yemekTeslimEdildi = ""

       var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
          updateUserInterface()

        payCashButton.isEnabled = false
        payCreditCardButton.isEnabled = false
  
        
  
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
 
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
                self.yemekTeslimEdildiArray.removeAll(keepingCapacity: false)
                self.objectIdArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                  
                    self.dateArray.append(object.object(forKey: "Date") as! String)
                    self.timeArray.append(object.object(forKey: "Time") as! String)
                     self.yemekTeslimEdildiArray.append(object.object(forKey: "YemekTeslimEdildi") as! String)
                    self.objectIdArray.append(object.objectId! )
                    
                    self.objectId = "\(self.objectIdArray.last!)"
                    self.date = "\(self.dateArray.last!)"
                    self.time = "\(self.timeArray.last!)"
                    self.yemekTeslimEdildi = "\(self.yemekTeslimEdildiArray.last!)"
                }

                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
               
            }
            
        }
    }
    
    @IBAction func payCashButtonClicked(_ sender: Any) {
    
        if  self.yemekTeslimEdildi != ""{
        
        var index = 0
        while index < self.objectIdArray.count{
        if objectIdArray.isEmpty == false{
        let query = PFQuery(className: "VerilenSiparisler")

        query.getObjectInBackground(withId: objectIdArray[index]) { (objects, error) in
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
             index += 1
    }
        }else{
            let alert = UIAlertController(title: "Yemek Henüz Telim Edilmedi", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    @IBAction func payCreditCardButtonPressed(_ sender: Any) {
        if self.yemekTeslimEdildi != ""{
        
        var index = 0
        while index < objectIdArray.count{
        
        if objectIdArray.isEmpty == false{
        let query = PFQuery(className: "VerilenSiparisler")
  
        query.getObjectInBackground(withId: objectIdArray[index]) { (objects, error) in
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
            index += 1
    }
        
    }
        else{
            let alert = UIAlertController(title: "Yemek Henüz Telim Edilmedi", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
