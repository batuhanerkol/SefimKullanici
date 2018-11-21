//
//  ShowBusinessDetails2VC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 29.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectedFoodFromMainPage = ""

class ShowBusinessDetails2VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var foodNameArray = [String]()
    var nameArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    var imageArray = [PFFile]()
    var emailArray = [String]()
    
    var email = ""


    @IBOutlet weak var foodNameTable: UITableView!
    @IBOutlet weak var poinstLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessLogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessNameLabel.text = globalSelectedBusinessName
        foodNameTable.dataSource = self
        foodNameTable.delegate = self
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if globalSelectedBusinessName != "" && globalFavBusinessName == "" {
        getFoodData()
        getBusinessLogo()
        }
        else if globalFavBusinessName != "" && globalSelectedBusinessName == ""{
            getFavFoodData()
            getFavBusinessLogo()
        }
    }
    func getFoodData(){
        
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("BusinessName", equalTo: globalSelectedBusinessName)
        query.whereKey("foodTitle", equalTo: globalSelectedTitleMainPage)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.foodNameArray.removeAll(keepingCapacity: false)
                self.priceArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodNameArray.append(object.object(forKey: "foodName") as! String)
                    self.priceArray.append(object.object(forKey: "foodPrice") as! String)
                }
                
            }
            self.foodNameTable.reloadData()
          
            
        }
        
    }
    func getBusinessLogo(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: globalSelectedBusinessName)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.imageArray.removeAll(keepingCapacity: false)
                self.emailArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    
                    self.email = "\(self.emailArray.last!)"
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            self.businessLogoImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
            }
        }
    }
    func getFavFoodData(){
        
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("BusinessName", equalTo: globalFavBusinessName)
        query.whereKey("foodTitle", equalTo: globalSelectedTitleMainPage)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.foodNameArray.removeAll(keepingCapacity: false)
                self.priceArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodNameArray.append(object.object(forKey: "foodName") as! String)
                    self.priceArray.append(object.object(forKey: "foodPrice") as! String)
                }
                
            }
            self.foodNameTable.reloadData()
        
            
        }
        
    }
    func getFavBusinessLogo(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: globalFavBusinessName)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.imageArray.removeAll(keepingCapacity: false)
                self.emailArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    
                    self.email = "\(self.emailArray.last!)"
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            self.businessLogoImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalSelectedFoodFromMainPage = foodNameArray[indexPath.row]
        
        performSegue(withIdentifier: "ShowBusinessDetails2VCToFoodInfo", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShowBusinessDetails2Cell
        
        cell.foodName.text = foodNameArray[indexPath.row]
        cell.foodPrice.text = priceArray[indexPath.row]
        return cell
    }
    @IBAction func adToFAvButton(_ sender: Any) {
        let object = PFObject(className: "FavorilerListesi")
        
        object["IsletmeSahibi"] = email
        object["SiparisSahibi"] = PFUser.current()?.username!
        object["IsletmeAdi"] = globalSelectedBusinessName
        
        object.saveInBackground { (success, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
                
            else{
                let alert = UIAlertController(title: "Favorilere Eklendi", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    

}
