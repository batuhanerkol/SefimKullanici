//
//  FavorilerimVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalFavBusinessName = ""

class FavorilerimVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var favoritesTable: UITableView!
    
    var favArray = [String]()
    var chosenFav = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        
        getFavBusinessName()
    
    }
    func getFavBusinessName(){
        
        let query = PFQuery(className: "FavorilerListesi")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.addDescendingOrder("createdAt")
        
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
               
                self.favArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                   
                    self.favArray.append(object.object(forKey: "IsletmeAdi") as! String)
                }
            }
            self.favoritesTable.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavorilerimCell", for: indexPath) as! FavorilerimCell
        cell.favLabel.text = favArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == favoritesTable{
            globalFavBusinessName = favArray[indexPath.row]
            
            if favArray[indexPath.row] != nil{
                self.performSegue(withIdentifier: "showBusinessInfo", sender: nil)
            }
        }
        
    }
}
