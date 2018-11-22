//
//  AnaSayfaVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectedBusinessName = ""

class AnaSayfaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favoritesArray = [String]()
    var previousBusinessArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    var favBusinessNameArray = [String]()
    
    var count = 0
    
    

    @IBOutlet weak var favTable: UITableView!
    @IBOutlet weak var previousBusinessNameTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favTable.delegate = self
        favTable.dataSource = self
        
        previousBusinessNameTable.delegate = self
        previousBusinessNameTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // favorilere bakarken hata vermemesi için
         globalFavBusinessName = ""
        globalBussinessEmail = ""
        
        getFavBusiness()
        getPreviousBusinessNameData()
    }
    
    func getPreviousBusinessNameData(){
        
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.whereKey("HesapOdendi", equalTo: "Evet")
         query.addDescendingOrder("createdAt")
         query.limit = 5
       
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.previousBusinessArray.removeAll(keepingCapacity: false)
                 self.dateArray.removeAll(keepingCapacity: false)
                 self.timeArray.removeAll(keepingCapacity: false)
              
                for object in objects! {

                    self.previousBusinessArray.append(object.object(forKey: "IsletmeAdi") as! String)
                     self.dateArray.append(object.object(forKey: "Date") as! String)
                     self.timeArray.append(object.object(forKey: "Time") as! String)
                    
                }
            
                 self.previousBusinessNameTable.reloadData()
            }
           
        }
    }
    func getFavBusiness(){
        
        let query = PFQuery(className: "FavorilerListesi")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.limit = 5
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.favoritesArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.favoritesArray.append(object.object(forKey: "IsletmeAdi") as! String)
                    
                }
                self.favTable.reloadData()
                print("Favoriler:" , self.favoritesArray)
      
            }
            
        }
    }
   

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == previousBusinessNameTable{
    globalSelectedBusinessName = previousBusinessArray[indexPath.row]
        
        if previousBusinessArray[indexPath.row] != nil{
       self.performSegue(withIdentifier: "anaSayfaToBusinessDetails", sender: nil)
          }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableView == self.favTable  {
            
            count = favBusinessNameArray.count
            return count
        }
        
      else {
              count = self.previousBusinessArray.count
            return count
        }
       
            
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == self.favTable){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellfavorite", for: indexPath) as! favoritesCell
                cell.favBusinessNameLabel.text = favoritesArray[indexPath.row]
                self.favTable.reloadData()
                return cell
            
        }
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrevious", for: indexPath) as! previousOrderCell
        cell.businessNameLabel.text = previousBusinessArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        
        return cell
       
                }
      
        }
    }

