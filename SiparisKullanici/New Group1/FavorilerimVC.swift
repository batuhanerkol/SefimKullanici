//
//  FavorilerimVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalFavBusinessNameFavorilerimVC = ""

class FavorilerimVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var favoritesTable: UITableView!
    
    var favArray = [String]()
    var chosenFav = ""
    var objectIdArray = [String]()
    var objectId = ""
    
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()

        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        

        
      
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
        
        globalSelectedBusinessNameAnaSayfaVC = ""
        globalFavBusinessNameFavorilerimVC = ""
        globalSelectedBusinessNameSearchVC = ""
        globalSelectedBusinessNameListOfSearchedFood = ""
    }
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            let alert = UIAlertController(title: "İnternet Bağlantınız Bulunmuyor.", message: "Lütfen Kontrol Edin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        case .wifi:
            getObjectId()
               getFavBusinessName()
        case .wwan:
              getObjectId()
               getFavBusinessName()
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
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
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.favoritesTable.reloadData()
        }
    }
    
    func deleteData(oderIndex : String){ // KAYDIRARAK SİLMEK İÇİN
        let query = PFQuery(className: "FavorilerListesi")
        //        query.whereKey("SiparisSahibi", equalTo: "\(PFUser.current()!.username!)")
        //        query.whereKey("SiparisAdi", equalTo: oderIndex )
        query.whereKey("objectId", equalTo: objectId)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.favArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    object.deleteInBackground()
                    self.getFavBusinessName()
                   
                }
                self.getFavBusinessName()
                self.favoritesTable.reloadData()
            }
        }
    }
    func getObjectId(){
  
        let query = PFQuery(className: "FavorilerListesi")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKeyExists("IsletmeAdi")
        query.addDescendingOrder("createdAt")
        
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
                   
                }
            }
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
            globalFavBusinessNameFavorilerimVC = favArray[indexPath.row]
            
            if favArray[indexPath.row] != ""{
                self.performSegue(withIdentifier: "showBusinessInfo", sender: nil)
            }
        }
        
    }
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = favArray[sourceIndexPath.row]
        favArray.remove(at: sourceIndexPath.row)
        favArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            getObjectId()
            objectId = objectIdArray[indexPath.row]
            deleteData(oderIndex: objectId)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
