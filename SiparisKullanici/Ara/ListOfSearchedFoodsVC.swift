//
//  ListOfSearchedFoodsVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 26.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectedBusinessNameListOfSearchedFood = ""

class ListOfSearchedFoodsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

    @IBOutlet weak var searchedFoodName: UILabel!
    @IBOutlet weak var businessNameTable: UITableView!
    
    var businessNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameTable.dataSource = self
        businessNameTable.delegate = self
        

        getFoodAccordinGLocation()
        searchedFoodName.text = globalSelectedFoodNameSearch
       
  }
    func getFoodAccordinGLocation(){
        print("globalSelectedFoodName:", globalSelectedFoodNameSearch)
        print("globalLong", globalCurrentLocationLongSearchVC)
        print("globalLat", globalCurrentLocationLatSearchVC)
 
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("foodName", equalTo: globalSelectedFoodNameSearch)
//        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: globalCurrentLocationLatSearchVC, longitude:  globalCurrentLocationLongSearchVC), withinKilometers: 5.0)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.businessNameArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.businessNameArray.append(object.object(forKey: "BusinessName") as! String)
                    print("BusinessName:", self.businessNameArray)
                }
            self.businessNameTable.reloadData()
            }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfSearchedFoodsCell", for: indexPath) as! ListOfSearchedFoodsCell
        
           cell.businessNameLabel.text = businessNameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if businessNameArray.isEmpty == false{
           globalSelectedBusinessNameListOfSearchedFood = businessNameArray[indexPath.row]
            
            if globalSelectedBusinessNameListOfSearchedFood != ""{
                self.performSegue(withIdentifier: "toShocBusinessDetails", sender: nil)
               
            }
        }
            
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
