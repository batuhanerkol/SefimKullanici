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
    
    var deliveredOrderNumberArray = [String]()
    var deliveredOrderNumber = ""
    
    var checkFoodNamesArray = [String]()
    var editingStyleCheck = true
    
  var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
  
    @IBOutlet weak var tableNumberButton: UIButton!
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
        
        // internet kontrolü
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
      
        
         dateTime()
        updateUserInterface()
        
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
   

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateTime()
        updateUserInterface()
        
        tableNumberLabel.text! = globalTableNumberEnterNumberVC
        
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            let alert = UIAlertController(title: "İnternet Bağlantınız Bulunmuyor.", message: "Lütfen Kontrol Edin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            self.giveOrderButton.isEnabled = false
            self.cancelButton.isEnabled = false
            self.payButton.isEnabled = false
        case .wifi:
            getOrderData()
            getObjectId()
            checkGivenOrder()
            getDeliveredORrderNumber()
            self.giveOrderButton.isEnabled = true
            self.cancelButton.isEnabled = true
            self.payButton.isEnabled = true
        case .wwan:
            getOrderData()
            getObjectId()
            checkGivenOrder()
            getDeliveredORrderNumber()
            self.giveOrderButton.isEnabled = true
            self.cancelButton.isEnabled = true
            self.payButton.isEnabled = true
        }
//        print("Reachability Summary")
//        print("Status:", status)
//        print("HostName:", Network.reachability?.hostname ?? "nil")
//        print("Reachable:", Network.reachability?.isReachable ?? "nil")
//        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

    

    func dateTime(){
        formatter.dateFormat = "dd/MM/yyyy"
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
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
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
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
          
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
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
     
        checkGivenOrder()
        if self.orderArray.isEmpty == false && self.checkFoodNamesArray != self.orderArray {
        
        if  self.deliveredOrderNumberArray.isEmpty == true{
             uploadOrderData()
       
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        else if self.deliveredOrderNumberArray.isEmpty == false {
            
           print("DEvieredArray", self.deliveredOrderNumberArray.last!)
            deletePreviousOrder()
 
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
  
         
    }
        else{
            let alert = UIAlertController(title: "Siparişiniz Boş veya Bir Değişiklik Yapılmamış", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
       
    }
    func uploadOrderData(){ 
        
        getOrderData()
  self.giveOrderButton.isEnabled = false
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
            object["TeslimEdilenSiparisSayisi"] = "0"
            
            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else{
                   
                    while self.siparisIndexNumber < self.orderArray.count{
                        self.siparislerChangeSituation()
                        self.siparisIndexNumber += 1
  
                    }
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    let alert = UIAlertController(title: "Sipariş Verilmiştir", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)

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
                            self.uploadOrderDataWithDeliveredOrderNumber()
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
    

    func uploadOrderDataWithDeliveredOrderNumber(){
        
        getOrderData()
        self.giveOrderButton.isEnabled = false
        
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
            object["TeslimEdilenSiparisSayisi"] = "\(self.deliveredOrderNumber)"
            
            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else{
                

                    while self.siparisIndexNumber < self.orderArray.count{
                        self.siparislerChangeSituation()
                        self.siparisIndexNumber += 1
                        
               
                    }
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    let alert = UIAlertController(title: "Sipariş Verilmiştir", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
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
             
                objects!["SiparisDurumu"] = "Verildi"
//                objects!["Date"] = self.dateLabel.text!
//                objects!["Time"] = self.timelabel.text!
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
    func checkGivenOrder(){ // hesabın ödenmediğinden emin olmak ve verilmiş sipariş sayısına bakmak için
        
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

                self.hesapOdendiArray.removeAll(keepingCapacity: false)
                 self.checkFoodNamesArray.removeAll(keepingCapacity: false)
        

                for object in objects! {


                    self.hesapOdendiArray.append(object.object(forKey: "HesapOdendi") as! String)
                    self.checkFoodNamesArray = object["SiparisAdi"] as! [String]
 
                    self.hesapOdendi = "\(self.hesapOdendiArray.last!)"
                    }
                print("hesapOdendi:", self.hesapOdendi)
                    if self.hesapOdendi == ""  {
                        

                    
                }
                
            }

        }
    }
    
    func getDeliveredORrderNumber(){ // hesabın ödenmediğinden emin olmak ve verilmiş sipariş sayısına bakmak için
        
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

                self.deliveredOrderNumberArray.removeAll(keepingCapacity: false)

                for object in objects! {
                    
                    self.deliveredOrderNumberArray.append(object.object(forKey: "TeslimEdilenSiparisSayisi") as! String)
                    
                    self.deliveredOrderNumber = "\(self.deliveredOrderNumberArray.last!)"
                }
                        print("delivered", self.deliveredOrderNumber)
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
    
    @IBAction func tableNumberButtonClicked(_ sender: Any) {
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



