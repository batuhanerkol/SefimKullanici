//
//  ListOfSearchedFoodsVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 26.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectedBusinessNameListOfSearchedFood = ""

class ListOfSearchedFoodsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  

    @IBOutlet weak var searchedFoodName: UILabel!
    @IBOutlet weak var businessNameTable: UITableView!
    
    var businessNameNearArray = [String]()
    var businessNameHasFoodArray = [String]()
    var testePointArray = [String]()
    var servicePointArray = [String]()
    var resultBusinessArray = [String]()
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        businessNameTable.dataSource = self
        businessNameTable.delegate = self
        
        searchedFoodName.text = globalSelectedFoodNameSearchVC
       
        
   
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
            
        case .wifi:
            getBusinessInfo()
            getBusinessNameHasFood()
            
            
        case .wwan:
            getBusinessInfo()
            getBusinessNameHasFood()
            
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func getBusinessNameHasFood(){
//        print("globalSelectedFoodName:", globalSelectedFoodNameSearch)
//        print("globalLong", globalCurrentLocationLongSearchVC)
//        print("globalLat", globalCurrentLocationLatSearchVC)
 
        let query = PFQuery(className: "FoodInformation")
        query.whereKey("foodName", equalTo: globalSelectedFoodNameSearchVC)
        query.whereKey("HesapOnaylandi", equalTo: "Evet")
        query.whereKey("MenudeGorunsun", equalTo: "Evet")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.businessNameHasFoodArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    self.businessNameHasFoodArray.append(object.object(forKey: "BusinessName") as! String)
                }
                print("AAA", self.businessNameHasFoodArray)
            }
        }
    }
    
    
    func getBusinessInfo(){
       
        let query = PFQuery(className: "BusinessInformation")
        query.whereKeyExists("businessName")
        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: globalCurrentLocationLatSearchVC, longitude:  globalCurrentLocationLongSearchVC), withinKilometers: 5.0)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.testePointArray.removeAll(keepingCapacity: false)
                self.servicePointArray.removeAll(keepingCapacity: false)
                 self.businessNameNearArray.removeAll(keepingCapacity: false)
                self.resultBusinessArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.testePointArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servicePointArray.append(object.object(forKey: "HizmetPuan") as! String)
                    self.businessNameNearArray.append(object.object(forKey: "businessName") as! String)
                    
                }
               
              print("---------------------------------------")
              print("businessHasFood:", self.businessNameHasFoodArray)
              print("businessNear:", self.businessNameNearArray)
              print("lezzetPuan:", self.testePointArray)
              print("hizmet:", self.servicePointArray)
               
                if self.businessNameHasFoodArray.isEmpty == false && self.businessNameNearArray.isEmpty == false{
                    
              self.resultBusinessArray = self.businessNameHasFoodArray.filter(self.businessNameNearArray.contains)
                    
                   
                print("resultBusinessArray:", self.resultBusinessArray)
                    
                }else{
                    self.viewWillAppear(false)
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.businessNameTable.reloadData()
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultBusinessArray.isEmpty == true{
            return 1
        }else{
        return resultBusinessArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfSearchedFoodsCell", for: indexPath) as! ListOfSearchedFoodsCell
        
        if resultBusinessArray.isEmpty == true{
            cell.businessNameLabel.text = "Yakınınız da Bulunmuyor"
            cell.pointsLabel.text = ""
        }else{
           cell.businessNameLabel.text = resultBusinessArray[indexPath.row]
            
          
                
                let query = PFQuery(className: "BusinessInformation")
                query.whereKey("businessName", equalTo: resultBusinessArray[indexPath.row])
             query.whereKey("HesapOnaylandi", equalTo: "Evet")
                query.addDescendingOrder("createdAt")
                
                query.findObjectsInBackground { (objects, error) in
                    if error != nil{
                        let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.testePointArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.testePointArray.append(object.object(forKey: "LezzetPuan") as! String)
                             cell.pointsLabel.text = self.testePointArray.last!
                        }
                    }
                }
        }
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if resultBusinessArray.isEmpty == false{
           globalSelectedBusinessNameListOfSearchedFood = resultBusinessArray[indexPath.row]
            
            if globalSelectedBusinessNameListOfSearchedFood != ""{
                self.performSegue(withIdentifier: "toShocBusinessDetails", sender: nil)
               
            }
        }
            
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

