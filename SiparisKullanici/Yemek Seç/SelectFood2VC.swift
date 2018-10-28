//
//  SelectFood2VC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 15.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class SelectFood2VC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    

    var chosenFood = ""
    var foodNameArray = [String]()
    var nameArray = [String]()
    var tableNumberArray = [String]()
    var priceArray = [String]()
    var imageArray = [PFFile]()
 
    @IBOutlet weak var businessLogoImage: UIImageView!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var selectFoodTable: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        selectFoodTable.delegate = self
        selectFoodTable.dataSource = self
        getFoodData()
        getBussinessNameData()
        getTableNumberData()
        getBusinessLogo()
    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "Locations")
        query.whereKey("businessLocationOwner", equalTo: globalStringValue)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.nameArray.append(object.object(forKey: "businessName") as! String)
                    
                    self.businessNameLabel.text = "\(self.nameArray.last!)"
                }
            }
        }
    }
    func getFoodData(){
        
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("foodNameOwner", equalTo: globalStringValue)
        query.whereKey("foodTitle", equalTo: selectecTitle)
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
            self.selectFoodTable.reloadData()
            
        }
        
    }
    func getTableNumberData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.tableNumberArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.tableNumberArray.append(object.object(forKey: "MasaNumarasi") as! String)
                    self.tableNumberLabel.text = "\(self.tableNumberArray.last!)"
                    
                }
                
            }
        }
    }
    func getBusinessLogo(){
        let query = PFQuery(className: "BusinessLOGO")
        query.whereKey("BusinessOwner", equalTo: globalStringValue)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.imageArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectFood2ToFoodInfo"{
            let destinationVC = segue.destination as! FoodInformationVC
            destinationVC.selectedFood = self.chosenFood
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenFood = foodNameArray[indexPath.row]
        
        performSegue(withIdentifier: "selectFood2ToFoodInfo", sender: nil)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = foodNameArray[sourceIndexPath.row]
        foodNameArray.remove(at: sourceIndexPath.row)
        foodNameArray.insert(item, at: destinationIndexPath.row)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return foodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectFood2VCTableViewCell
        
        cell.foodNameLabel.text = foodNameArray[indexPath.row]
        cell.priceLabel.text = priceArray[indexPath.row]
        return cell
    }
    @IBAction func addTableButtonClicked(_ sender: Any) {
    }
}
