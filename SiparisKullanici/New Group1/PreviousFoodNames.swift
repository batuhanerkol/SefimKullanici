//
//  PreviousFoodNames.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 5.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class PreviousFoodNames: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var chosenBusiness = ""
    var chosenDate = ""
    var chosenTime = ""
    
    var foodPriceArray = [String]()
    var foodNameArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    var totalPriceArray = [String]()
    
    @IBOutlet weak var dislikeServiceButton: UIButton!
    @IBOutlet weak var likedServiceButton: UIButton!
    @IBOutlet weak var dislikeTesteButton: UIButton!
    @IBOutlet weak var likedTesteButton: UIButton!
    @IBOutlet weak var yorumTextField: UITextView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var foodNameTabLeView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameTabLeView.delegate = self
        foodNameTabLeView.dataSource = self

       getPreviousFoodData()
        
       
    }
    
    func getPreviousFoodData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
      
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.dateArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)
                self.totalPriceArray.removeAll(keepingCapacity: false)
                self.foodNameArray.removeAll(keepingCapacity: false)
                self.foodPriceArray.removeAll(keepingCapacity: false)
                
                
                for object in objects! {
                 
                    self.foodNameArray = object["SiparisAdi"] as! [String]
                    self.foodPriceArray = object["SiparisFiyati"] as! [String]
                    self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)
                    
                     self.totalPriceLabel.text = "\(self.totalPriceArray.last!)"
                
                }
            }
            self.foodNameTabLeView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousFoodNameCell", for: indexPath) as! PreviousFoodNameCell
        cell.foodNameLabel.text = foodNameArray[indexPath.row]
        cell.foodPriceLabel.text = foodPriceArray[indexPath.row]
        
        return cell
    }
    
    @IBAction func likedFoodTesteButtonClicked(_ sender: Any) {
       
       
        
        let foodRaiting = PFObject(className: "VerilenSiparislerDegerlendirme")
        foodRaiting["IsletmeAdi"] = chosenBusiness
        foodRaiting["PuanlananSiparis"] = foodNameArray
        foodRaiting["SiparisBegenilmeDurumu"] = 1
        foodRaiting["SiparisVerilmeTarihi"] = chosenDate
        foodRaiting["SiparisVerilmeSaati"] = chosenTime
    
        foodRaiting.saveInBackground { (success, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                   self.likedTesteButton.removeFromSuperview()
                self.dislikeTesteButton.removeFromSuperview()
                
            }
        }
        
        }

    @IBAction func dislikeFoodTesteButtonPressed(_ sender: Any) {
    }
    
    @IBAction func likedServiceButtonCliecked(_ sender: Any) {
    }
    @IBAction func dislikeServiceButtonCliced(_ sender: Any) {
    }
    @IBAction func saveTextButtonClicked(_ sender: Any) {
    }
    
}
