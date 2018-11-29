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
    var allBusinessHasFoodArray = [String]()
    var testePointArray = [String]()
    var servicePointArray = [String]()
    var searchedBusinessArray = [String]()
    var resultBusinessArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameTable.dataSource = self
        businessNameTable.delegate = self
        
          searchedFoodName.text = globalSelectedFoodNameSearch
        
        getBusinessNameHasFood()
        getBusinessInfo()
  }
    // seçilmş yemeği menüsünde bulunduran işletmeler elimizce, yakınımızda olan işletmeler elimizde , eşleşenleri table da göster
    
    func getBusinessNameHasFood(){
//        print("globalSelectedFoodName:", globalSelectedFoodNameSearch)
//        print("globalLong", globalCurrentLocationLongSearchVC)
//        print("globalLat", globalCurrentLocationLatSearchVC)
 
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("foodName", equalTo: self.searchedFoodName.text!)

        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.allBusinessHasFoodArray.removeAll(keepingCapacity: false)
                 self.searchedBusinessArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    self.allBusinessHasFoodArray.append(object.object(forKey: "BusinessName") as! String)
                }
                self.searchedBusinessArray.append(contentsOf: self.allBusinessHasFoodArray)
                
                
          
            }
        }
    }
    
    
    func getBusinessInfo(){
       
        let query = PFQuery(className: "BusinessInformation")
        query.whereKeyExists("businessName")
        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: globalCurrentLocationLatSearchVC, longitude:  globalCurrentLocationLongSearchVC), withinKilometers: 5.0)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.testePointArray.removeAll(keepingCapacity: false)
                self.servicePointArray.removeAll(keepingCapacity: false)
                 self.businessNameArray.removeAll(keepingCapacity: false)
                self.resultBusinessArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.testePointArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servicePointArray.append(object.object(forKey: "HizmetPuan") as! String)
                    self.businessNameArray.append(object.object(forKey: "businessName") as! String)
                    
                }
               
                print("---------------------------------------")
              print("allbusiness:", self.allBusinessHasFoodArray)
              print("businessNameArray:", self.businessNameArray)
               
              self.resultBusinessArray = self.allBusinessHasFoodArray.filter(self.businessNameArray.contains)
                
                print("resultBusinessArray:", self.resultBusinessArray)
                self.businessNameTable.reloadData()
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultBusinessArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfSearchedFoodsCell", for: indexPath) as! ListOfSearchedFoodsCell
        
           cell.businessNameLabel.text = resultBusinessArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if resultBusinessArray.isEmpty == false{
           globalSelectedBusinessNameListOfSearchedFood = resultBusinessArray[indexPath.row]
            
            if globalSelectedBusinessNameListOfSearchedFood != ""{
                self.performSegue(withIdentifier: "toShocBusinessDetails", sender: nil)
               
            }
        }
            
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

