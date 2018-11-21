//
//  FavoriBusinessInformation.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class FavoriBusinessInformation: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var imageArray = [PFFile]()
    var emailArray = [String]()
    var foodTitleArray = [String]()
    
    var email = ""
    
    @IBOutlet weak var foodTitleTable: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTitleTable.dataSource = self
        foodTitleTable.delegate = self

        businessNameLabel.text = globalFavBusinessName
      getBusinessLogo()
        getFoodTitleData()
    }
    func getBusinessLogo(){
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
                            self.businessLogo.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
            }
        }
    }
    func getFoodTitleData(){
        
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
            self.foodTitleTable.reloadData()
        }
    }
    @IBAction func konumButtonPressed(_ sender: Any) {
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  foodTitleArray[indexPath.row]
        return cell
    }
    

}
