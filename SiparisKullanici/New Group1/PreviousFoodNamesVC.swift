//
//  PreviousFoodNamesVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 3.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class PreviousFoodNamesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var foodNamesTableView: UITableView!
    
    var chosenBusiness = ""
    var chosenDate = ""
    var chosenTime = ""
    
    var foodNamesArray = [String]()
    var totalPriceArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNamesTableView.delegate = self
        foodNamesTableView.dataSource = self

        print(chosenBusiness)
       print(chosenDate)
        print(chosenTime)
        getPreviousFoodNames()
    }
    func getPreviousFoodNames(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{


                self.foodNamesArray.removeAll(keepingCapacity: false)
                self.totalPriceArray.removeAll(keepingCapacity: false)
                
                for object in objects! {

                    self.foodNamesArray = object["SiparisAdi"] as! [String]
                    self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    
                    self.totalPriceLabel.text = "\(self.totalPriceArray.last!)"
                }
            }
            
            self.foodNamesTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodNamesCell", for: indexPath) as! FoodNamesCell
        cell.foodNameLabel.text! = foodNamesArray[indexPath.row]
    
        return cell
        
    }


}
