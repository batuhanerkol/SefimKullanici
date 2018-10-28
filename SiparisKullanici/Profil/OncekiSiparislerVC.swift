//
//  OncekiSiparislerVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class OncekiSiparislerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var previousBusinessNameArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    var totalPriceArray = [String]()
    var previousFoodNameArray = [String]()
   
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
  
    }
    override func viewWillAppear(_ animated: Bool) {
      getPreviousData()
    }
    
  
    
    func getPreviousData(){
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
                self.previousBusinessNameArray.removeAll(keepingCapacity: false)
                self.previousFoodNameArray.removeAll(keepingCapacity: false)
                self.totalPriceArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)

                for object in objects! {
                    self.previousBusinessNameArray.append(object.object(forKey: "IsletmeAdi") as! String)
                    self.dateArray.append(object.object(forKey: "Date") as! String)
                    self.timeArray.append(object.object(forKey: "Time") as! String)
                    
                }
            }
            self.ordersTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousBusinessNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellPrevious", for: indexPath) as! PreviousOrdersTVC
        cell1.businessNameLabel.text = previousBusinessNameArray[indexPath.row]
        cell1.dateLabel.text = dateArray[indexPath.row]
        cell1.timeLabel.text = timeArray[indexPath.row]
        
        return cell1
    }
    
    
  

}
