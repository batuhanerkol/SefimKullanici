//
//  OrdersVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 17.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse


class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let currentDateTime = Date()
    let formatter = DateFormatter()
    let formatterTime = DateFormatter()
    
     var totalPrice = 0
   
    var orderArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    var orderNoteArray = [String]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
           dateTime()
        
        if globalTableNumber != "" {
            tableNumberLabel.text = globalTableNumber
             getOrderData()
//            calculateSumPrice()
        }
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
            self.orderTableView.reloadData()
          
        }
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
    func deleteData(oderIndex : String){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        query.whereKey("SiparisAdi", equalTo: oderIndex )

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
                
            }
        }
    }
    func deleteGivenOrderData(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        query.whereKey("MasaNumarasi", equalTo: globalTableNumber)
        
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
                    self.orderTableView.reloadData()
                    self.getOrderData()
                }
                
            }
        }
    }
    @IBAction func orderButtonClicked(_ sender: Any) {
        
        if orderTableView.visibleCells.isEmpty {
            
            let alert = UIAlertController(title: "Lütfen Yemek Seçin", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            let object = PFObject(className: "VerilenSiparisler")
            
            object["SiparisAdi"] = orderArray
            object["SiparisFiyati"] = priceArray
            object["IsletmeSahibi"] = globalStringValue
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["MasaNo"] = globalTableNumber
            object["ToplamFiyat"] = sumOfPriceLabel.text!
            object["IsletmeAdi"] = globalBusinessName
            object["YemekNotu"] = orderNoteArray
            object["Date"] = dateLabel.text!
            object["Time"] = timelabel.text!
            
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
                    
                }
            }
        }
        
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        deleteGivenOrderData()
    }
    @IBAction func payButtonClicked(_ sender: Any) {
        deleteGivenOrderData()
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
                        let orderIndex = orderTableView.cellForRow(at: indexPath)?.textLabel?.text!
            
                        orderArray.remove(at: indexPath.item)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        deleteData(oderIndex: orderIndex!)
                    }
                }
   
    }

