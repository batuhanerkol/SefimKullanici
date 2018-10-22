//
//  AnaSayfaVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse
class AnaSayfaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favoritesArray = [String]()
    var previousBusinessArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    
    
    @IBOutlet weak var favoritesTable: UITableView!
    @IBOutlet weak var previousOrdersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previousOrdersTable.delegate = self
        previousOrdersTable.dataSource = self
     
        getPreviousBusinessNameData()
    }
    override func viewWillAppear(_ animated: Bool) {
        getPreviousBusinessNameData()
    }

    
    func getPreviousBusinessNameData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
       
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.previousBusinessArray.removeAll(keepingCapacity: false)
                 self.dateArray.removeAll(keepingCapacity: false)
                 self.timeArray.removeAll(keepingCapacity: false)
              
                for object in objects! {
//                    self.previousBusinessArray = object["IsletmeAdi"] as! [String]
                 
                    self.previousBusinessArray.append(object.object(forKey: "IsletmeAdi") as! String)
                     self.dateArray.append(object.object(forKey: "Date") as! String)
                     self.timeArray.append(object.object(forKey: "Time") as! String)
                    //                    self.priceArray.append(object.object(forKey: "SiparisFiyati") as! String)
                    
                }
            }
            self.previousOrdersTable.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousBusinessArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrevious", for: indexPath) as! previousOrderCell
        cell.businessNameLabel.text = previousBusinessArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        
        return cell
        
        //        else if tableView == favoritesTable{
        ////            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrevious", for: indexPath) as! previousOrderCell
        ////            cell.foodNameLabel.text = favoritesArray[indexPath.row]
        ////            return cell
        //        }
        
    }
}
