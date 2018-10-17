//
//  OrdersVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 17.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class OrdersVC: UIViewController {
    
    var orderArray = [String]()

    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
getOrderData()
    }
    
    @IBAction func orderButtonClicked(_ sender: Any) {
    }
    

 

    func getOrderData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: globalStringValue)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.orderArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.orderArray.append(object.object(forKey: "SiparisAdi") as! String)
                    
                }
                self.orderTableView.reloadData()
                
            }
        }
    }
}
