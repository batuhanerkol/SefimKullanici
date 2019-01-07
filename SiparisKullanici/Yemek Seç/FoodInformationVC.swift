//
//  FoodInformationVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 15.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class FoodInformationVC: UIViewController, UITextFieldDelegate {
    
    var selectedFood = ""
    var foodNameArray = [String]()
    var foodInformationArray = [String]()
    var foodPriceArray = [String]()
    var imageArray = [PFFile]()
    var businessNameArray = [String]()
    var yemekHammaddeAdi = [String]()
    var yemekHammaddeMiktari = [String]()

     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var addToOrderButton: UIButton!
    @IBOutlet weak var foodNoteTextField: UITextField!
    @IBOutlet weak var foodInfoText: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        foodNoteTextField.delegate = self
        foodNoteTextField.text = ""
        
        self.addToOrderButton.isEnabled = false
        
        
     
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
          updateUserInterface()
    }
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            let alert = UIAlertController(title: "İnternet Bağlantınız Bulunmuyor.", message: "Lütfen Kontrol Edin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            self.addToOrderButton.isEnabled = false
        case .wifi:
            getBussinessNameData()
            findFood()
            self.addToOrderButton.isEnabled = true
            
        case .wwan:
            
            getBussinessNameData()
            findFood()
            self.addToOrderButton.isEnabled = true
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    
    
    func findFood(){
        let query = PFQuery(className: "FoodInformation")
         query.whereKey("foodNameOwner", equalTo: globalBussinessEmailQRScannerVC)
        query.whereKey("foodName", equalTo: self.selectedFood)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
             
                self.foodNameArray.removeAll(keepingCapacity: false)
                self.foodInformationArray.removeAll(keepingCapacity: false)
                self.foodPriceArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                self.yemekHammaddeAdi.removeAll(keepingCapacity: false)
                self.yemekHammaddeMiktari.removeAll(keepingCapacity: false)
            
                
                for object in objects!{
                
                    self.foodNameArray.append(object.object(forKey: "foodName") as! String)
                    self.foodInformationArray.append(object.object(forKey: "foodInformation") as! String)
                    self.foodPriceArray.append(object.object(forKey: "foodPrice") as! String)
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
             
                    
                    
                    self.foodNameLabel.text = "\(self.foodNameArray.last!)"
                    self.foodInfoText.text = "\(self.foodInformationArray.last!)"
                    self.priceLabel.text = "\(self.foodPriceArray.last!)"
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{ 
                            self.foodImage.image = UIImage(data: (data)!)
                        }
                    })
                    self.addToOrderButton.isEnabled = true

                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    func getBussinessNameData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessUserName", equalTo: globalBussinessEmailQRScannerVC)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.businessNameArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.businessNameArray.append(object.object(forKey: "businessName") as! String)
                    
                    globalBusinessNameEnterNumberVC = "\(self.businessNameArray.last!)"
                }
            }
        }
    }
    @IBAction func AddToOrderButtonClicked(_ sender: Any) {
 self.addToOrderButton.isHidden = true
        
            let object = PFObject(className: "Siparisler")

            object["SiparisAdi"] = foodNameLabel.text!
            object["SiparisFiyati"] = priceLabel.text!
            object["IsletmeSahibi"] = globalBussinessEmailQRScannerVC
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["MasaNumarasi"] = globalTableNumberEnterNumberVC
            object["YemekNotu"] = foodNoteTextField.text!
            object["IsletmeAdi"] = globalBusinessNameEnterNumberVC
            object["SiparisDurumu"] = ""
            object["HammaddeAdi"] = self.yemekHammaddeAdi
            object["HammaddeMiktari"] = self.yemekHammaddeMiktari
        

            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{

                    self.navigationController?.popViewController(animated: true)
                  
                }
            }
        }
    func deleteData(){
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        query.whereKey("SiparisAdi", equalTo: "")
        query.whereKey("MasaNumarasi", equalTo: globalTableNumberEnterNumberVC)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
             
                for object in objects! {
                    object.deleteInBackground()
                  
                }
                
            }
        }
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


