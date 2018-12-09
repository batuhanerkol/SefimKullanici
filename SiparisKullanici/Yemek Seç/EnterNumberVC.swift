//
//  EnterNumberVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalTableNumberEnterNumberVC: String = ""
var globalBusinessNameEnterNumberVC = ""

class EnterNumberVC: UIViewController {

    var nameArray = [String]()
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBussinessNameData()
        
       
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
                for object in objects!{
                  
                    
                    self.businessNameLabel.text = (object.object(forKey: "businessName") as! String)
                    globalBusinessNameEnterNumberVC = (object.object(forKey: "businessName") as! String)
                }
            }
        }
    }

    @IBAction func OKButtonPressed(_ sender: Any) {
        
        if numberTextField.text != ""{
            globalTableNumberEnterNumberVC = self.numberTextField.text!
            self.performSegue(withIdentifier: "enterNumberToSelectFood", sender: nil)
            
        }else{
            let alert = UIAlertController(title: "Lütfen Masa Numaranızı Giriniz", message: "", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
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
