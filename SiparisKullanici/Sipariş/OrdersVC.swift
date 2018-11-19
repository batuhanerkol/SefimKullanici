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
var globalDateForPayment = ""
var globalTimeForPayment = ""


class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let currentDateTime = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
    var totalPrice = 0
    var objectId = ""
    var foodName = ""
    var totalCheckPrice = ""
    var hesapCheck = ""
   
    var orderArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    var orderNoteArray = [String]()
    var objectIdArray = [String]()
    
    var priceCheckArray = [String]()
    var foodNameArray = [String]()
    var hesapCheckArray = [String]()
  
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
    
          dateTime()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self

       payButton.isEnabled = false
     
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        
         chechGivenOrder()
           getObjectId()
        
        if globalTableNumber != "" {
            tableNumberLabel.text = globalTableNumber
             getOrderData()
        }
       
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
    
        deleteEmtyData()
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("MasaNumarasi", equalTo: globalTableNumber)
        
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
            if self.orderArray.isEmpty == false && self.priceArray.isEmpty == false && self.orderNoteArray.isEmpty == false {
            self.orderTableView.reloadData()

            }
        }
         self.payButton.isEnabled = true
        
    }
    
    func getTableNumberData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.tableNumberArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.tableNumberArray.append(object.object(forKey: "MasaNumarasi") as! String)
                    self.tableNumberLabel.text = "\(self.tableNumberArray.last!)"
                    
                }
                
            }
        }
    }
    func deleteData(oderIndex : String){ // KAYDIRARAK SİLMEK İÇİN
        let query = PFQuery(className: "Siparisler")
//        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
//        query.whereKey("SiparisAdi", equalTo: oderIndex )
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
                    object.deleteInBackground()
                    self.orderTableView.reloadData()
                    self.getOrderData()
                }
            self.orderTableView.reloadData()
            }
        }
    }
    func deleteGivenOrderData(){ // BÜTÜN SİPARİŞİ SİLMEK İÇİN
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        query.whereKey("MasaNumarasi", equalTo: globalTableNumber)
        query.whereKey("Date", notEqualTo: dateLabel.text!)
        query.whereKey("Time", notEqualTo: timelabel.text!)
        
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
                    self.orderTableView.reloadData()
                    self.sumOfPriceLabel.text = ""
                }
                
            }
        }
    }
    func deleteEmtyData(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        query.whereKey("SiparisAdi", equalTo: "" )
        
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
                  
                    self.getOrderData()
                    self.orderTableView.reloadData()
                }
                
            }
        }
    }
    @IBAction func orderButtonClicked(_ sender: Any) {
     
        if orderTableView.visibleCells.isEmpty == false && orderArray.isEmpty == false && priceArray.isEmpty == false && orderNoteArray.isEmpty == false {
            
            let object = PFObject(className: "VerilenSiparisler")
            
            object["SiparisAdi"] = orderArray
            object["SiparisFiyati"] = priceArray
            object["IsletmeSahibi"] = globalBussinessEmail
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["MasaNo"] = globalTableNumber
            object["ToplamFiyat"] = sumOfPriceLabel.text!
            object["IsletmeAdi"] = globalBusinessName
            object["YemekNotu"] = orderNoteArray
            object["Date"] = dateLabel.text!
            object["Time"] = timelabel.text!
            object["HesapOdendi"] = ""
            object["HesapIstendi"] = ""
            object["SiparisVerildi"] = "Evet"
            
            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                  
                        
                    let alert = UIAlertController(title: "Sipariş Verilmiştir", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.payButton.isEnabled = true
                    globalTimeForPayment = self.timelabel.text!
                    globalDateForPayment = self.dateLabel.text!
                        
                    
                    
                }
            }
        
        }else{
            let alert = UIAlertController(title: "Bir Sorun Oluştu Lütfen Tekrar Deneyin", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func chechGivenOrder(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
        query.whereKey("MasaNo", equalTo: globalTableNumber)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessName)
//        query.addDescendingOrder("createdAt")
     
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
            
                self.priceArray.removeAll(keepingCapacity: false)
                self.orderNoteArray.removeAll(keepingCapacity: false)
                self.hesapCheckArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    self.foodNameArray = object["SiparisAdi"] as! [String]
                    self.priceCheckArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    self.hesapCheckArray.append(object.object(forKey: "HesapOdendi") as! String)

                    self.foodName = "\(self.foodNameArray.last!)"
                    self.totalCheckPrice = "\(self.priceCheckArray.last!)"
                    self.hesapCheck = "\(self.hesapCheckArray.last!)"
                    
                   
                    }
                
                    if self.hesapCheck == "Evet"{
                    self.deleteGivenOrderData()
                }
               
            }

        }
    }
    func getObjectId(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("MasaNumarasi", equalTo: globalTableNumber)
        
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
      
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
        query.whereKey("MasaNo", equalTo: globalTableNumber)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessName)
        query.whereKey("Date", equalTo: dateLabel.text!)
        query.whereKey("Time", equalTo: timelabel.text!)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.priceArray.removeAll(keepingCapacity: false)
                self.orderNoteArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    self.foodNameArray = object["SiparisAdi"] as! [String]
                    self.priceCheckArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    
                    self.foodName = "\(self.foodNameArray.last!)"
                    self.totalCheckPrice = "\(self.priceCheckArray.last!)"
                }
                print(self.foodName)
                print(self.totalCheckPrice)
                
                if self.foodName != "" || self.totalCheckPrice != "" {
                    let alert = UIAlertController(title: "Siparişiniz Mutfağa İletilmiştir Ne Yazik ki İptal Edemezsiniz...", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else  if self.foodName == "" || self.totalCheckPrice == "" {
                      self.deleteGivenOrderData()
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! OrderTableViewCell
        cell.foodNameLabel.text = orderArray[indexPath.row]
        cell.priceLabel.text = priceArray[indexPath.row]
        cell.orderNoteLabel.text = orderNoteArray[indexPath.row]
    
     
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
        if (editingStyle == .delete) {
            objectId = objectIdArray[indexPath.row]
            deleteData(oderIndex: objectId)
   
    }
}
}
