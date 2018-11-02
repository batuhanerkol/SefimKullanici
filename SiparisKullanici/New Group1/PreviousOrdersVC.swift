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

class PreviousOrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
                    //                    self.previousBusinessArray = object["IsletmeAdi"] as! [String]
                    self.previousBusinessNameArray.append(object.object(forKey: "IsletmeAdi") as! String)
                    self.dateArray.append(object.object(forKey: "Date") as! String)
                    self.timeArray.append(object.object(forKey: "Time") as! String)
                   globalPreviousFoodNameArray = object["SiparisAdi"] as! [String]
                    self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    //                 self.priceArray.append(object.object(forKey: "SiparisFiyati") as! String)
                    
                }
            }
            self.previousOrderTableView.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        cell.totalPriceLabel.text = totalPriceArray[indexPath.row]
        cell.textLabel?.text = globalPreviousFoodNameArray[indexPath.row]
        
        return cell
        }
        else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! previousOrderCell
            cell.foodName
            
            
              
        }
    return UITableViewCell()
    }
  

}
