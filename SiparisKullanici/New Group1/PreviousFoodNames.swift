//
//  PreviousFoodNames.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 5.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class PreviousFoodNames: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    
    var chosenBusiness = ""
    var chosenDate = ""
    var chosenTime = ""
    var objectId = ""
    var previousRateTeste = ""
    var previousRateServis = ""
    
    var foodPriceArray = [String]()
    var foodNameArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    var totalPriceArray = [String]()
    var objectIdArray = [String]()
    var previosusRateTesteArray = [String]()
    var previosusRateServiceArray = [String]()
    var yorumArray = [String]()
    
    @IBOutlet weak var dislikeServiceButton: UIButton!
    @IBOutlet weak var likedServiceButton: UIButton!
    @IBOutlet weak var dislikeTesteButton: UIButton!
    @IBOutlet weak var likedTesteButton: UIButton!
    @IBOutlet weak var yorumTextField: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var foodNameTabLeView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameTabLeView.delegate = self
        foodNameTabLeView.dataSource = self
        yorumTextField.delegate = self

        getObjectId()
        checkTesteRateData()
        checkServiceRateData()
        checkYorumData()
        getPreviousFoodData()
        
        
       
    }
    
    func getPreviousFoodData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
      
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.dateArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)
                self.totalPriceArray.removeAll(keepingCapacity: false)
                self.foodNameArray.removeAll(keepingCapacity: false)
                self.foodPriceArray.removeAll(keepingCapacity: false)
        
                
                for object in objects! {
                 
                    self.foodNameArray = object["SiparisAdi"] as! [String]
                    self.foodPriceArray = object["SiparisFiyati"] as! [String]
                    self.totalPriceArray.append(object.object(forKey: "ToplamFiyat") as! String)

                    
                     self.totalPriceLabel.text = "\(self.totalPriceArray.last!)"
                    
                }
            }
            self.foodNameTabLeView.reloadData()
        }
    }
    func checkTesteRateData(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        query.whereKeyExists("LezzetBegeniDurumu")
    
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "Lütfen Tekrar Deneyin", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.previosusRateTesteArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.previosusRateTesteArray.append(object.object(forKey: "LezzetBegeniDurumu") as! String)
                    self.previousRateTeste = "\(self.previosusRateTesteArray.last!)"
                    print(self.previousRateTeste)
                }
               
                if objects != nil{
                    
                    if self.previousRateTeste == "1"{
                    
                        self.likedTesteButton.isHidden = false
                        self.likedTesteButton.isEnabled = false
                        self.dislikeTesteButton.isHidden = true
                        
                    }else if self.previousRateTeste == "0"{
                        
                        self.likedTesteButton.isHidden = true
                        self.dislikeTesteButton.isEnabled = false
                        self.dislikeTesteButton.isHidden = false
                    }

                    if objects == Optional([]){
                       
                        self.likedTesteButton.isHidden = false
                        self.dislikeTesteButton.isHidden = false
                }
            }
        }
    }
    }
    func checkServiceRateData(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        query.whereKeyExists("HizmetBegenilmeDurumu")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "Lütfen Tekrar Deneyin", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.previosusRateServiceArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.previosusRateServiceArray.append(object.object(forKey: "HizmetBegenilmeDurumu") as! String)
                    self.previousRateServis = "\(self.previosusRateServiceArray.last!)"
                    print(self.previousRateServis)
                }
                
                if objects != nil{
                     if self.previousRateServis == "1"{
                        
                    self.likedServiceButton.isHidden = false
                    self.likedServiceButton.isEnabled = false
                    self.dislikeServiceButton.isHidden = true
                        
                     }else if self.previousRateServis == "0"{
                        
                        self.likedServiceButton.isHidden = true
                        self.dislikeServiceButton.isEnabled = false
                        self.dislikeServiceButton.isHidden = false
                    }
                    if objects == Optional([]){
                        
                        self.likedServiceButton.isHidden = false
                        self.dislikeServiceButton.isHidden = false
                        
                        
                    }
                }
            }
        }
    }
    func checkYorumData(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        query.whereKeyExists("YapilanYorum")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                for object in objects! {
                    self.yorumArray.append(object.object(forKey: "YapilanYorum") as! String)
                    self.yorumTextField.text = "\(self.yorumArray.last!)"
              
                }
                if objects != nil{
            
                    self.saveButton.isHidden = true
                    
                    if objects == Optional([]){
                        
                        self.saveButton.isHidden = false
                    }
                }
            }
        }
    }
    func getObjectId(){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("IsletmeAdi", equalTo: chosenBusiness)
        query.whereKey("Date", equalTo: chosenDate)
        query.whereKey("Time", equalTo: chosenTime)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.objectIdArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.objectIdArray.append(object.objectId!)
                    
                    self.objectId = "\(self.objectIdArray.last!)"
                }
            }
        }
    }
   
    @IBAction func likedFoodTesteButtonClicked(_ sender: Any) {
       
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKeyExists("LezzetBegeniDurumu")
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                print(self.objectId)
                objects!["LezzetBegeniDurumu"] = "1"
                objects!.saveInBackground()
            }
        }
        self.likedTesteButton.isHidden = true
        self.dislikeTesteButton.isHidden = true
        }
    
   
    @IBAction func dislikeFoodTesteButtonPressed(_ sender: Any) {
        let query = PFQuery(className: "VerilenSiparisler")
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                objects!["LezzetBegeniDurumu"] = "0"
                objects!.saveInBackground()
            }
        }
        self.likedTesteButton.isHidden = true
        self.dislikeTesteButton.isHidden = true
        
        
    }
    
    @IBAction func likedServiceButtonCliecked(_ sender: Any) {

         let query = PFQuery(className: "VerilenSiparisler")
        query.whereKeyExists("HizmetBegenilmeDurumu")
            query.getObjectInBackground(withId: objectId) { (objects, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    print(self.objectId)
                    objects!["HizmetBegenilmeDurumu"] = "1"
                    objects!.saveInBackground()
                }
            }
            
        
        
        self.likedServiceButton.isHidden = true
        self.dislikeServiceButton.isHidden = true

    }
    @IBAction func dislikeServiceButtonCliced(_ sender: Any) {
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                objects!["HizmetBegenilmeDurumu"] = "0"
                objects!.saveInBackground()
            }
        }
        
        
        
        self.likedServiceButton.isHidden = true
        self.dislikeServiceButton.isHidden = true

        
    }

    @IBAction func saveTextButtonClicked(_ sender: Any) {
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKeyExists("YapılanYorum")
        query.getObjectInBackground(withId: objectId) { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                print(self.objectId)
                objects!["YapilanYorum"] = self.yorumTextField.text!
                objects!.saveInBackground()
                self.saveButton.isHidden = true
                
                let alert = UIAlertController(title: "Yorumunuz İşletmeye İletilmiştir, Bilgileriniz Bizimle Güvende :)", message: "", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousFoodNameCell", for: indexPath) as! PreviousFoodNameCell
        cell.foodNameLabel.text = foodNameArray[indexPath.row]
        cell.foodPriceLabel.text = foodPriceArray[indexPath.row]
        
        return cell
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
