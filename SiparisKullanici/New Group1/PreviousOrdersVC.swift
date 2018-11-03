//
//  PreviousOrdersVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalPreviousFoodNameArray = [String]()
var globalSelectedPreviousDate = ""

class PreviousOrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var choosenBusiness = ""
    var chosenDate = ""
    var chosenTime = ""
    
     var previousBusinessNameArray = [String]()
     var dateArray = [String]()
     var timeArray = [String]()
     var totalPriceArray = [String]()

    @IBOutlet weak var previousOrderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previousOrderTableView.delegate = self
        previousOrderTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getPreviousBusinessNameData()
    }
    func getPreviousBusinessNameData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.addDescendingOrder("createdAt")
        
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.previousBusinessNameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)
                globalPreviousFoodNameArray.removeAll(keepingCapacity: false)
                self.totalPriceArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.previousBusinessNameArray.append(object.object(forKey: "IsletmeAdi") as! String)
                    self.dateArray.append(object.object(forKey: "Date") as! String)
                    self.timeArray.append(object.object(forKey: "Time") as! String)
                    globalPreviousFoodNameArray = object["SiparisAdi"] as! [String]
                    self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)
                }
            }
            self.previousOrderTableView.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return previousBusinessNameArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! Cell1
        cell.businessNameLabel.text = previousBusinessNameArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        chosenDate = cell.dateLabel.text!
        chosenTime = cell.timeLabel.text!
        
        return cell
        }
        else  if indexPath.section == 1{
          let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell2", for: indexPath) as! PreviousCell2
            cell.foodNameLAbel.text = globalPreviousFoodNameArray[indexPath.row]
        
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell3", for: indexPath) as! PreviousCell3
            cell.totalPriceLAbel.text = totalPriceArray[indexPath.row]
            
            return cell
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previosBusinessToPreviousFoods"{
            let destinationVC = segue.destination as! PreviousFoodNamesVC
            destinationVC.chosenBusiness = self.choosenBusiness
            destinationVC.chosenDate = self.chosenDate
            destinationVC.chosenTime = self.chosenTime
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.choosenBusiness = previousBusinessNameArray[indexPath.row]
        self.performSegue(withIdentifier: "previosBusinessToPreviousFoods", sender: nil)
    }
 

}
