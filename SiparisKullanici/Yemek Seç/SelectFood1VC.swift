//
//  SelectFood1VC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 15.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectecTitleSelectFood1 = ""

class SelectFood1VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var nameArray = [String]()
    var foodTitleArray = [String]()
    var tableNumberArray = [String]()
    var imageArray = [PFFile]()
    var testeArray = [String]()
    var serviceArray = [String]()
    
    var chosenFood = ""

    @IBOutlet weak var lezzetLabel: UILabel!
    @IBOutlet weak var hizmetLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var businessLogoImage: UIImageView!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var foodTitleTable: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodTitleTable.delegate = self
        foodTitleTable.dataSource = self
        
        getFoodTitleData()
        getBussinessNameData()
        getTableNumberData()
        getBusinessLogo()
        
        tableNumberLabel.text = globalTableNumberEnterNumberVC
        
        navigationItem.hidesBackButton = true
    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessUserName", equalTo: globalBussinessEmailQRScannerVC)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                self.serviceArray.removeAll(keepingCapacity: false)
                self.testeArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.nameArray.append(object.object(forKey: "businessName") as! String)
                    self.serviceArray.append(object.object(forKey: "HizmetPuan") as! String)
                    self.testeArray.append(object.object(forKey: "LezzetPuan") as! String)
                    
                    self.hizmetLabel.text = "\(self.serviceArray.last!)"
                     self.lezzetLabel.text = "\(self.testeArray.last!)"
                    self.businessNameLabel.text = "\(self.nameArray.last!)"
                }
            }
        }
    }

    func getFoodTitleData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("foodTitleOwner", equalTo: globalBussinessEmailQRScannerVC)
       
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
                self.foodTitleTable.reloadData()
               
            }
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
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessUserName", equalTo: globalBussinessEmailQRScannerVC)
        
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
    @IBAction func showLocationButtonPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectFood1ToSelectFood2"{
            let destinationVC = segue.destination as! SelectFood2VC
            destinationVC.chosenFood = self.chosenFood
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenFood = foodTitleArray[indexPath.row]
        
        globalSelectecTitleSelectFood1 = (foodTitleTable.cellForRow(at: indexPath)?.textLabel?.text)!
        
        self.performSegue(withIdentifier: "selectFood1ToSelectFood2", sender: nil)

    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = foodTitleArray[sourceIndexPath.row]
        foodTitleArray.remove(at: sourceIndexPath.row)
        foodTitleArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = foodTitleArray[indexPath.row]
        return cell
    }
    @IBAction func favButtonPressed(_ sender: Any) {
            
        let object = PFObject(className: "FavorilerListesi")
        
            object["IsletmeSahibi"] = globalBussinessEmailQRScannerVC
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["IsletmeAdi"] = globalBusinessNameEnterNumberVC
            
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
