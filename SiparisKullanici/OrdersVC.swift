//
//  OrdersVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 17.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var orderArray = [String]()

    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
            getOrderData()
    }
    
    @IBAction func orderButtonClicked(_ sender: Any) {
    }
    

 

    func getOrderData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: PFUser.current()?.username)
      
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
                
            }
            self.orderTableView.reloadData()
    }
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = orderArray[indexPath.row]
        return cell
    }
    
}
