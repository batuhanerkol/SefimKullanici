//
//  ShowBusinessDetailsVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import  Parse

 var globalSelectedTitleShowDetails1 = ""

class ShowBusinessDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     var nameArray = [String]()
     var foodTitleArray = [String]()
     var imageArray = [PFFile]()
     var emailArray = [String]()
     var lezzetArray = [String]()
     var servisArray = [String]()

    var email = ""
    
    @IBOutlet weak var servisPuanLAbel: UILabel!
    @IBOutlet weak var lezzetPuanLabel: UILabel!
    @IBOutlet weak var titleNameTable: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var businessLogoImage: UIImageView!
 

    override func viewDidLoad() {
        super.viewDidLoad()

       titleNameTable.delegate = self
        titleNameTable.dataSource = self
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
    
        if globalSelectedBusinessName != "" && globalFavBusinessName == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == "" {
            
           businessNameLabel.text = globalSelectedBusinessName
            
            getBusinessLogo()
            getFoodTitleData()
            
     
            
        }
        else if globalFavBusinessName != "" && globalSelectedBusinessName == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
            businessNameLabel.text = globalFavBusinessName
            
            getFavFoodTitleData()
            getFavBusinessLogo()
     
        }
        else if globalFavBusinessName == "" && globalSelectedBusinessName == "" && globalSelectedBusinessNameSearchVC != "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
            businessNameLabel.text = globalSelectedBusinessNameSearchVC
                      getSearchBusinessData()
            getSearchBusinessLogo()
            
        }
        else if globalFavBusinessName == "" && globalSelectedBusinessName == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood != ""{
            
            
            businessNameLabel.text = globalSelectedBusinessNameListOfSearchedFood
            getSearchedBusinessFromFoodData()
            getSearchedBusinessLogoFromFoodData()
            
        }

       
    }
    func getFoodTitleData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("BusinessName", equalTo: globalSelectedBusinessName)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
               
                self.foodTitleArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                    
                }
            }
              self.titleNameTable.reloadData()
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
                self.lezzetArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)
                
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                    self.lezzetPuanLabel.text = "\(self.lezzetArray.last!)"
                    self.servisPuanLAbel.text = "\(self.servisArray.last!)"
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
                self.lezzetArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                    
                    self.lezzetPuanLabel.text = "\(self.lezzetArray.last!)"
                    self.servisPuanLAbel.text = "\(self.servisArray.last!)"
                    
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
    func getFavFoodTitleData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("BusinessName", equalTo: globalFavBusinessName)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.foodTitleArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                    
                }
            }
            self.titleNameTable.reloadData()
            self.businessNameLabel.text = globalFavBusinessName
        }
    }
    
    
    
    func getSearchBusinessData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("BusinessName", equalTo: globalSelectedBusinessNameSearchVC)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.foodTitleArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                    
                }
            }
            self.titleNameTable.reloadData()
        }
    }
    
    func getSearchBusinessLogo(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: globalSelectedBusinessNameSearchVC)
        
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
                self.lezzetArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)
                
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                    
                    self.lezzetPuanLabel.text = "\(self.lezzetArray.last!)"
                    self.servisPuanLAbel.text = "\(self.servisArray.last!)"
                    
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
    
    func getSearchedBusinessFromFoodData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("BusinessName", equalTo: globalSelectedBusinessNameListOfSearchedFood)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.foodTitleArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                    
                }
            }
            self.titleNameTable.reloadData()
        }
    }
    
    func getSearchedBusinessLogoFromFoodData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: globalSelectedBusinessNameListOfSearchedFood)
        
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
                self.lezzetArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)

                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                    
                    self.lezzetPuanLabel.text = "\(self.lezzetArray.last!)"
                    self.servisPuanLAbel.text = "\(self.servisArray.last!)"
                    
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
    
    @IBAction func addToFavButtonPressed(_ sender: Any) {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        globalSelectedTitleShowDetails1 = (titleNameTable.cellForRow(at: indexPath)?.textLabel?.text)!
        
        self.performSegue(withIdentifier: "showDetails1To2", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  foodTitleArray[indexPath.row]
        return cell
    }
    
    
    
    @IBAction func showBusinessLocaButtonPressed(_ sender: Any) {
    }
   
    
}
