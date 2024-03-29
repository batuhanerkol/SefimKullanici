//
//  FoodInfo.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 29.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class FoodInfo: UIViewController {
    
    var foodNameArray = [String]()
    var foodInformationArray = [String]()
    var foodPriceArray = [String]()
    var imageArray = [PFFile]()
    
      var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var foodInfoLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
           
            self.findFood(IsletmeAdi: globalSelectedBusinessNameAnaSayfaVC)
           
        }
        else if globalFavBusinessNameFavorilerimVC != "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
          
            self.findFood(IsletmeAdi: globalFavBusinessNameFavorilerimVC)
            
        }
        else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC != "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
           self.findFood(IsletmeAdi: globalSelectedBusinessNameSearchVC)
            
            
        }else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood != ""{
            
          self.findFood(IsletmeAdi: globalSelectedBusinessNameListOfSearchedFood)
            
        }
    }
    func findFood(IsletmeAdi:String){
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("BusinessName", equalTo: IsletmeAdi)
        query.whereKey("foodName", equalTo: globalSelectedFoodFromMainPage)
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
                self.foodInformationArray.removeAll(keepingCapacity: false)
                self.foodPriceArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.foodNameArray.append(object.object(forKey: "foodName") as! String)
                    self.foodInformationArray.append(object.object(forKey: "foodInformation") as! String)
                    self.foodPriceArray.append(object.object(forKey: "foodPrice") as! String)
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    
                    self.foodNameLabel.text = "\(self.foodNameArray.last!)"
                    self.foodInfoLabel.text = "\(self.foodInformationArray.last!)"
                    self.foodPriceLabel.text = "\(self.foodPriceArray.last!)"
                    
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
                            self.foodImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

}


