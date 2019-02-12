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
    var lezzetArray = [String]()
    var servisArray = [String]()
    
    var email = ""

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var yogunlukLabel: UILabel!
    @IBOutlet weak var lezzetNameLabel: UILabel!
    @IBOutlet weak var servisNameLabel: UILabel!
    @IBOutlet weak var servisLabel: UILabel!
    @IBOutlet weak var lezzetLabel: UILabel!
    @IBOutlet weak var foodNameTable: UITableView!
    @IBOutlet weak var poinstLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessLogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessNameLabel.text = globalSelectedBusinessNameAnaSayfaVC
        foodNameTable.dataSource = self
        foodNameTable.delegate = self
        
        
    
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if globalSelectedBusinessNameAnaSayfaVC != "" && globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
        getFoodData(IsletmeAdi: globalSelectedBusinessNameAnaSayfaVC)
        getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameAnaSayfaVC)
            
            businessNameLabel.text = globalSelectedBusinessNameAnaSayfaVC
        }
        else if globalFavBusinessNameFavorilerimVC != "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            getFoodData(IsletmeAdi: globalFavBusinessNameFavorilerimVC)
            getBusinessLogo(IsletmeAdi: globalFavBusinessNameFavorilerimVC)
            
            businessNameLabel.text = globalFavBusinessNameFavorilerimVC
        }
        else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC != "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            getFoodData(IsletmeAdi: globalSelectedBusinessNameSearchVC)
            getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameSearchVC)
            
            businessNameLabel.text = globalSelectedBusinessNameSearchVC
            
        }else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood != ""{
            
            getFoodData(IsletmeAdi: globalSelectedBusinessNameListOfSearchedFood)
            getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameListOfSearchedFood)
            
            businessNameLabel.text = globalSelectedBusinessNameListOfSearchedFood
        }
    }
    func getFoodData(IsletmeAdi:String){
        
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("BusinessName", equalTo: IsletmeAdi)
        query.whereKey("foodTitle", equalTo: globalSelectedTitleShowDetails1)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        query.whereKey("MenudeGorunsun", equalTo: "Evet")
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
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
    func getBusinessLogo(IsletmeAdi:String){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: IsletmeAdi)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                
                self.imageArray.removeAll(keepingCapacity: false)
                self.emailArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)
                self.lezzetArray.removeAll(keepingCapacity: false)
             
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                    
                     self.lezzetLabel.text = "\(self.lezzetArray.last!)"
                     self.servisLabel.text = "\(self.servisArray.last!)"
                    
                    self.email = "\(self.emailArray.last!)"
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        else{
                            self.businessLogoImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
                if Double(self.servisLabel.text!)! < 2.5{
                    self.servisLabel.backgroundColor = .orange
                    self.servisNameLabel.backgroundColor = .orange
                    if Double(self.servisLabel.text!)! < 1{
                        self.servisLabel.backgroundColor = .red
                        self.servisNameLabel.backgroundColor = .red
                    }
                }
                if Double(self.lezzetLabel.text!)! < 2.5{
                    self.lezzetLabel.backgroundColor = .orange
                    self.lezzetNameLabel.backgroundColor = .orange
                    if Double(self.lezzetLabel.text!)! < 1{
                        self.lezzetLabel.backgroundColor = .red
                        self.lezzetNameLabel.backgroundColor = .red
                    }
                }
                self.yogunlukLabel.text = "%\(globalYogunlukOraniShowDetails1)"
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
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
        object["IsletmeAdi"] = businessNameLabel.text!
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
