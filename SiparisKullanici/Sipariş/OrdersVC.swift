//
//  OrdersVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 17.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse


// Öde (nakit-kredi) basıldığında verilen siparişin hesabını, siparişin verildiği tarihe göre seçmek için.


class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let currentDateTime = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    var siparisIndexNumber = 0
    var totalPrice = 0
    var objectId = ""
    var foodName = ""
    var totalCheckPrice = ""
    var hesapOdendi = ""
   
    var orderArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    var orderNoteArray = [String]()
    var objectIdArray = [String]()
    
    var priceCheckArray = [String]()
    var foodNameArray = [String]()
    var hesapOdendiArray = [String]()
    
    var editingStyleCheck = true
    
  
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var giveOrderButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sumOfPriceLabel: UILabel!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
         dateTime()
        
        tableNumberLabel.text = globalTableNumberEnterNumberVC
        
        getOrderData()
        getObjectId()
        chechGivenOrder()
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateTime()
        getOrderData()
        getObjectId()
         chechGivenOrder()
       
    }
    func dateTime(){
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let loc = Locale(identifier: "tr")
        formatter.locale = loc
        let dateString = formatter.string(from: currentDateTime)
        dateLabel.text! = dateString
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        timelabel.text = ("\(hour)  \(minute)")
    }
    
    func calculateSumPrice(){
       
             totalPrice = 0
        
            for string in priceArray{
                if string != "" {
                    let myInt = Int(string)!
                    totalPrice = totalPrice + myInt
                }
        }
        sumOfPriceLabel.text = String(totalPrice)
       
    }

    func getOrderData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("MasaNumarasi", equalTo: globalTableNumberEnterNumberVC)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.orderArray.removeAll(keepingCapacity: false)
                self.priceArray.removeAll(keepingCapacity: false)
                self.orderNoteArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.orderArray.append(object.object(forKey: "SiparisAdi") as! String)
                    self.priceArray.append(object.object(forKey: "SiparisFiyati") as! String)
                    self.orderNoteArray.append(object.object(forKey: "YemekNotu") as! String)


                }
                self.calculateSumPrice()
            }
            self.orderTableView.reloadData()
          
        }
        
    }
    
    func deleteData(oderIndex : String){ // KAYDIRARAK SİLMEK İÇİN
        let query = PFQuery(className: "Siparisler")
       query.whereKey("SiparisDurumu", equalTo: "")
       query.whereKey("objectId", equalTo: objectId)

        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.orderArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    object.deleteInBackground(block: { (sucess, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
                self.getOrderData()
             
            }
        }
    }
    
    
    func deleteGivenOrderData(){ // BÜTÜN SİPARİŞİ SİLMEK İÇİN
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()!.username!))
        query.whereKey("MasaNumarasi", equalTo: globalTableNumberEnterNumberVC)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("SiparisDurumu", equalTo: "")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.orderArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    object.deleteInBackground()

                    self.sumOfPriceLabel.text = ""
                    self.orderTableView.reloadData()
                }
                
            }
        }
    }
   
    @IBAction func orderButtonClicked(_ sender: Any) {
     
         chechGivenOrder()
        
        if self.hesapOdendiArray.isEmpty == true{
             uploadOrderData()
        }else if self.hesapOdendiArray.isEmpty == false{
            deletePreviousOrder()
            
        }
  
      
    }
    
    func uploadOrderData(){
        
        getOrderData()
       
  
        if orderTableView.visibleCells.isEmpty == false && orderArray.isEmpty == false && priceArray.isEmpty == false && orderNoteArray.isEmpty == false {
            
            let object = PFObject(className: "VerilenSiparisler")
            
            object["SiparisAdi"] = orderArray
            object["SiparisFiyati"] = priceArray
            object["IsletmeSahibi"] = globalBussinessEmailQRScannerVC
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["MasaNo"] = globalTableNumberEnterNumberVC
            object["ToplamFiyat"] = sumOfPriceLabel.text!
            object["IsletmeAdi"] = globalBusinessNameEnterNumberVC
            object["YemekNotu"] = orderNoteArray
            object["Date"] = dateLabel.text!
            object["Time"] = timelabel.text!
            object["HesapOdendi"] = ""
            object["HesapIstendi"] = ""
            object["SiparisVerildi"] = "Evet"
            object["YapilanYorum"] = ""
            object["LezzetBegeniDurumu"] = ""
            object["HizmetBegenilmeDurumu"] = ""
            object["YemekTeslimEdildi"] = ""
            object["YemekHazir"] = ""
            
            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else{
                    let alert = UIAlertController(title: "Sipariş Verilmiştir", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
//                    self.payButton.isEnabled = true
//                    self.editingStyleCheck = false
//                    self.giveOrderButton.isEnabled = false
//                    self.cancelButton.isEnabled = false
                    
                    while self.siparisIndexNumber < self.orderArray.count{
                        self.siparislerChangeSituation()
                        self.siparisIndexNumber += 1
                    }
                }
            }
            
        }else{
            
            let alertController = UIAlertController(title: "Lütfen Tekrar Deneyin", message: "", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.getOrderData()
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func deletePreviousOrder(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("MasaNo", equalTo: globalTableNumberEnterNumberVC)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessNameEnterNumberVC)
        query.whereKey("HesapOdendi", equalTo: "")
        
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                for object in objects! {
                    object.deleteInBackground(block: { (success, error) in
                        
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            
                        }else{
                            self.uploadOrderData()
                            let alert = UIAlertController(title: "Siparişinize Eklenmiştir", message: "", preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func siparislerChangeSituation(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("MasaNumarasi", equalTo: tableNumberLabel.text!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKeyExists("SiparisDurumu")
        
        query.getObjectInBackground(withId: objectIdArray[siparisIndexNumber]) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if  self.dateLabel.text! != "" && self.timelabel.text! != ""{
                objects!["SiparisDurumu"] = "Verildi"
                objects!["Date"] = self.dateLabel.text!
                objects!["Time"] = self.timelabel.text!
                objects!.saveInBackground(block: { (success, error) in
                    if error != nil{
                        let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
            }
            }
        }
        
    }
    func chechGivenOrder(){
     
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("MasaNo", equalTo: globalTableNumberEnterNumberVC)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessNameEnterNumberVC)
        query.whereKey("HesapOdendi", equalTo: "")
     
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                self.orderTableView.reloadData()
            }
            else{

//                self.priceArray.removeAll(keepingCapacity: false)
//                self.orderNoteArray.removeAll(keepingCapacity: false)
                self.hesapOdendiArray.removeAll(keepingCapacity: false)

                for object in objects! {

//                    self.foodNameArray = object["SiparisAdi"] as! [String]
//                    self.priceCheckArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    self.hesapOdendiArray.append(object.object(forKey: "HesapOdendi") as! String)

//                    self.foodName = "\(self.foodNameArray.last!)"
//                    self.totalCheckPrice = "\(self.priceCheckArray.last!)"
                    self.hesapOdendi = "\(self.hesapOdendiArray.last!)"

                    }
                print("hesapOdendi:", self.hesapOdendi)
                    if self.hesapOdendi == ""  {
                        
//                        self.editingStyleCheck = false
//                        self.giveOrderButton.isEnabled = false
//                        self.cancelButton.isEnabled = false
                    
                }
                
            }

        }
    }
    
    
    func getObjectId(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("MasaNumarasi", equalTo: globalTableNumberEnterNumberVC)
        
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
                    self.objectIdArray.append(object.objectId!)
                    
                }
            }
        }
    }
    
   
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
            self.deleteGivenOrderData()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! OrderTableViewCell
        //index out or range hatası almamak için
        if indexPath.row < orderArray.count && indexPath.row < priceArray.count && indexPath.row < orderNoteArray.count{
        cell.foodNameLabel.text = orderArray[indexPath.row]
        cell.priceLabel.text = priceArray[indexPath.row]
        cell.orderNoteLabel.text = orderNoteArray[indexPath.row]
    }
     
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = orderArray[sourceIndexPath.row]
        orderArray.remove(at: sourceIndexPath.row)
        orderArray.insert(item, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && editingStyleCheck == true{
            
            objectId = objectIdArray[indexPath.row]
            deleteData(oderIndex: objectId)
   
    }
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}



