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
    
    var chosenBusiness = ""
    var favBusinessName = ""
    
    

    @IBOutlet weak var favTable: UITableView!
    @IBOutlet weak var previousBusinessNameTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previousBusinessNameTable.delegate = self
        previousBusinessNameTable.dataSource = self
        
        favTable.delegate = self
        favTable.dataSource = self
     
        getFavBusiness()
        getPreviousBusinessNameData()
        
       
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
         globalFavBusinessName = ""
        globalBussinessEmail = ""
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
                print(self.previousBusinessArray)
                 self.previousBusinessNameTable.reloadData()
            }
           
        }
    }
    func getFavBusiness(){
        
        let query = PFQuery(className: "FavorilerListesi")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
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
                
                self.favoritesArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.favoritesArray.append(object.object(forKey: "IsletmeAdi") as! String)
                    
                }
                self.favTable.reloadData()
                print(self.favoritesArray)
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anaSayfaToBusinessDetails"{
            let destinationVC = segue.destination as! ShowBusinessDetailsVC
            destinationVC.chosenBusinessName = self.chosenBusiness
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
       
        if (tableView == previousBusinessNameTable){
        return previousBusinessArray.count
        }
        else  {
            return favBusinessNameArray.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == favTable){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellfavorite", for: indexPath) as! favoritesCell
                cell.favBusinessNameLabel.text = favoritesArray[indexPath.row]
                
                return cell
            
        }
        else if (tableView == previousBusinessNameTable){
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrevious", for: indexPath) as! previousOrderCell
        cell.businessNameLabel.text = previousBusinessArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        
        return cell
       
                }
              return UITableViewCell()
        }
    }

