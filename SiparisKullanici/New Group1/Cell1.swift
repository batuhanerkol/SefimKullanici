//
//  Cell1.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class Cell1: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var previousFoodNameArray = [String]()
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var foodNamesTableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodNamesTableView.delegate = self
        foodNamesTableView.dataSource = self
        
        foodNameData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func foodNameData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
//                self.present(alert, animated: true, completion: nil)
            }
            else{
              
                self.previousFoodNameArray.removeAll(keepingCapacity: false)
                
                for object in objects! {

                    self.previousFoodNameArray = object["SiparisAdi"] as! [String]
                    
                }
            }
            self.foodNamesTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousFoodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Cell2InCell1
        
        cell.foodNameLabel.text = previousFoodNameArray[indexPath.row]
        
        return cell
        
    }
    


}
