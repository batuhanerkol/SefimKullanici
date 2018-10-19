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

     var total = 0
    
    var orderArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    
    @IBOutlet weak var sumOfPriceLabel: UILabel!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if globalTableNumber != "" {
            tableNumberLabel.text = globalTableNumber
            if tableNumberLabel.text == globalTableNumber{
               
                getOrderData()
            }
        }
        sumOfPriceLabel.text = ""
        for string in priceArray{
            let myInt = Int(string)!
            total = total + myInt
        }
        print(total)
        sumOfPriceLabel.text = String(total)
    }
    
    @IBAction func orderButtonClicked(_ sender: Any) {
    }
    
    func getOrderData(){
    
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
                for object in objects! {
                    self.orderArray.append(object.object(forKey: "SiparisAdi") as! String)
                    self.priceArray.append(object.object(forKey: "SiparisFiyati") as! String)
                    
                    self.deleteEmtyData()
                }
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! OrderTableViewCell
        cell.priceLabel.text = priceArray[indexPath.row]
        cell.foodNameLabel.text = orderArray[indexPath.row]
        
       print(cell.priceLabel.text)
       print(priceArray.count)

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

