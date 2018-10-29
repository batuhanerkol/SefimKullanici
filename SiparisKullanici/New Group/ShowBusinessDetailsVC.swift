//
//  ShowBusinessDetailsVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import  Parse

 var globalSelectedTitleMainPage = ""

class ShowBusinessDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     var nameArray = [String]()
     var foodTitleArray = [String]()
     var imageArray = [PFFile]()
    
    var chosenBusinessName = ""
    
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
        businessNameLabel.text = globalSelectedBusinessName
        if businessNameLabel.text != ""{
  
        getBusinessLogo()
            getFoodTitleData()
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
        let query = PFQuery(className: "BusinessLOGO")
        query.whereKey("BusinessName", equalTo: globalSelectedBusinessName)
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        globalSelectedTitleMainPage = (titleNameTable.cellForRow(at: indexPath)?.textLabel?.text)!
        
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