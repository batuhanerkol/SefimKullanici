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

       payButton.isEnabled = false
     
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        dateTime()
        getObjectId()
        
        if self.orderTableView.visibleCells.isEmpty == true{
            payButton.isEnabled = false
            giveOrderButton.isEnabled = false
            cancelButton.isEnabled = false
        }else if self.orderTableView.visibleCells.isEmpty == false{
            payButton.isEnabled = true
            giveOrderButton.isEnabled = true
            cancelButton.isEnabled = true
        }
        
         chechGivenOrder()
        
        
        if globalTableNumber != "" {
            tableNumberLabel.text = globalTableNumber
             getOrderData()
        }else{
            print("BURADA HATA VAR")
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
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
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
     
       uploadOrderData()
    }
    func uploadOrderData(){
        print("table" , self.orderTableView.visibleCells.isEmpty)
        print("food" , self.orderArray)
        print("price" , self.priceArray)
        print("note" , orderNoteArray)
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
            object["YapilanYorum"] = ""
            object["LezzetBegeniDurumu"] = ""
            object["HizmetBegenilmeDurumu"] = ""
            
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
                    
                    self.payButton.isEnabled = true
                    self.editingStyleCheck = false
                    self.cancelButton.isEnabled = false
                    
                    while self.siparisIndexNumber < self.objectIdArray.count{
                        self.siparislerChangeSituation()
                        self.siparisIndexNumber += 1
                    }
                }
            }
            
        }else{
            
            let alertController = UIAlertController(title: "Bir Sorun Oluştu Lütfen Tekrar Deneyin", message: "", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.getOrderData()
                self.giveOrderButton.isEnabled = true
                
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    func siparislerChangeSituation(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("MasaNumarasi", equalTo: tableNumberLabel.text!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
        query.whereKeyExists("SiparisDurumu")
        
        query.getObjectInBackground(withId: objectIdArray[siparisIndexNumber]) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                objects!["SiparisDurumu"] = "Verildi"
                objects!["Date"] = self.dateLabel.text!
                objects!["Time"] = self.timelabel.text!
                objects!.saveInBackground()
                
            }
        }
        
    }
    func chechGivenOrder(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
        query.whereKey("MasaNo", equalTo: globalTableNumber)
        query.whereKey("IsletmeAdi", equalTo: globalBusinessName)
        query.whereKey("HesapOdendi", notEqualTo: "Evet")
     
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                self.orderTableView.reloadData()
            }
            else{

                self.priceArray.removeAll(keepingCapacity: false)
                self.orderNoteArray.removeAll(keepingCapacity: false)
                self.hesapOdendiArray.removeAll(keepingCapacity: false)

                for object in objects! {

                    self.foodNameArray = object["SiparisAdi"] as! [String]
                    self.priceCheckArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    self.hesapOdendiArray.append(object.object(forKey: "HesapOdendi") as! String)

                    self.foodName = "\(self.foodNameArray.last!)"
                    self.totalCheckPrice = "\(self.priceCheckArray.last!)"
                    self.hesapOdendi = "\(self.hesapOdendiArray.last!)"

                    }

                    if self.totalCheckPrice != "" || self.foodName != "" || self.hesapOdendi != ""  {
                  
                        
                        self.editingStyleCheck = false
                        self.giveOrderButton.isEnabled = false
                        
                }
                        self.orderTableView.reloadData()
                
            }

        }
    }
    
    
    func getObjectId(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
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
        
        if self.totalCheckPrice != "" || self.foodName != "" || self.hesapOdendi != ""  {
            
            let alert = UIAlertController(title: "Siparişiniz Mutfağa İletilmiştir Ne Yazik ki İptal Edemezsiniz...", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            self.deleteGivenOrderData()
           
        }
        
//        let query = PFQuery(className: "VerilenSiparisler")
//        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
//        query.whereKey("IsletmeSahibi", equalTo: globalBussinessEmail)
//        query.whereKey("MasaNo", equalTo: globalTableNumber)
//        query.whereKey("IsletmeAdi", equalTo: globalBusinessName)
//        query.whereKey("HesapOdendi", equalTo: "")
////        query.whereKey("Date", equalTo: dateLabel.text!)
////        query.whereKey("Time", equalTo: timelabel.text!)
//
//        query.findObjectsInBackground { (objects, error) in
//
//            if error != nil{
//                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
//                alert.addAction(okButton)
//                self.present(alert, animated: true, completion: nil)
//            }
//            else{
//
//                self.foodNameArray.removeAll(keepingCapacity: false)
//                self.priceCheckArray.removeAll(keepingCapacity: false)
//
//                for object in objects! {
//
//                    self.foodNameArray = object["SiparisAdi"] as! [String]
//                    self.priceCheckArray.append(object.object(forKey: "ToplamFiyat") as! String)
//
//                    self.foodName = "\(self.foodNameArray.last!)"
//                    self.totalCheckPrice = "\(self.priceCheckArray.last!)"
//                }
//
//                if self.foodName != "" && self.totalCheckPrice != "" {
//                    let alert = UIAlertController(title: "Siparişiniz Mutfağa İletilmiştir Ne Yazik ki İptal Edemezsiniz...", message: "", preferredStyle: UIAlertController.Style.alert)
//                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
//                    alert.addAction(okButton)
//                    self.present(alert, animated: true, completion: nil)
//
//                }else  if self.foodName == "" || self.totalCheckPrice == "" {
//                      self.deleteGivenOrderData()
//                }
//            }
//
//        }
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



