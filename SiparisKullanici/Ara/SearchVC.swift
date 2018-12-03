//
//  SearchVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 22.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectedBusinessNameSearchVC = ""
var globalSelectedFoodNameSearchVC = ""

var globalCurrentLocationLongSearchVC: Double = 0
var globalCurrentLocationLatSearchVC: Double = 0

class SearchVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var businessNameTable: UITableView!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var offerTableView: UITableView!
    
    var businessNameArray = [String]()
    var searchBusinessArray = [String]()
    
    var foodNameArray = [String]()
    var searchedFoodNameArray = [String]()
    
    var testePointArray = [String]()
    
    var isSearching = false
    
    let locationManager = CLLocationManager()
    
    var longiduteDouble: Double = 0
    var latitudeDouble: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameTable.delegate = self
        businessNameTable.dataSource = self
        
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        getBussinessNameData()
        getFoodNameData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        globalSelectedBusinessNameAnaSayfa = ""
        globalFavBusinessNameFavorilerimVC = ""
        globalBussinessEmailQRScannerVC = ""
        globalSelectedBusinessNameSearchVC = ""
        globalSelectedBusinessNameListOfSearchedFood = ""
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        globalCurrentLocationLatSearchVC = locValue.latitude
        globalCurrentLocationLongSearchVC = locValue.longitude
        self.longiduteDouble = locValue.longitude
        self.latitudeDouble = locValue.latitude
    }
    
    func getBusinessNameAccordinGLocation(){
        
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: self.latitudeDouble, longitude:  self.longiduteDouble), withinKilometers: 5.0)
        query.limit = 5
        
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
                    

                }
             
            }
        }
    }
//    func getFoodAccordinGLocation(){ // henüz tamamlanmadı
//
//        let query = PFQuery(className: "FoodInformation")
//        query.whereKey("BusinessName", equalTo: self.businessNameArray.last!)
//        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: self.latitudeDouble, longitude:  self.longiduteDouble), withinKilometers: 5.0)
//        query.limit = 5
//
//        query.findObjectsInBackground { (objects, error) in
//            if error != nil{
//                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
//                alert.addAction(okButton)
//                self.present(alert, animated: true, completion: nil)
//            }
//            else{
//                self.businessNameArray.removeAll(keepingCapacity: false)
//                for object in objects!{
//                    self.businessNameArray.append(object.object(forKey: "businessName") as! String)
//                }
//            }
//        }
//    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKeyExists("businessName")
        query.whereKeyExists("LezzetPuan")
        query.limit = 5
      
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.businessNameArray.removeAll(keepingCapacity: false)
                 self.testePointArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.businessNameArray.append(object.object(forKey: "businessName") as! String)
                    self.testePointArray.append(object.object(forKey: "LezzetPuan") as! String)
                    
                }
                
            }
            self.businessNameTable.reloadData()
        }
       
    }
    
    func getFoodNameData(){
        let query = PFQuery(className: "FoodInformation")
          query.whereKeyExists("BusinessName")
       
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.foodNameArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodNameArray.append(object.object(forKey: "foodName") as! String)
                }
                
            }
            print("FoodName:", self.foodNameArray)
            self.foodsTableView.reloadData()
           self.locationManager.stopUpdatingLocation()
        }
  
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       
        if isSearching ==  true{
            if (tableView == businessNameTable){
                return searchBusinessArray.count

            }
            else  {
                return searchedFoodNameArray.count

            }
        }
        else{
            if (tableView == businessNameTable){
                return 1
                
            }
            else {
                return 1
                
            }
        }
      
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if (tableView == businessNameTable){
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantsTVC

            if isSearching == true{
                cell.businessNameLabel.text = searchBusinessArray[indexPath.row]
             
            }
            else{
                cell.businessNameLabel.text = "Henüz Arama Yapmadınız"
//                cell.testePointLabel.text = testePointArray[indexPath.row]
            }
        return cell
            
        }

       else if (tableView == foodsTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! foodTVC

            if isSearching == true{
                cell.foodNameLabel.text = searchedFoodNameArray[indexPath.row]
            }
            else{
                cell.foodNameLabel.text = "Henüz Arama Yapmadınız"
            }

            return cell
        }
        
        if (tableView == businessNameTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantsTVC
            cell.businessNameLabel.text = businessNameArray[indexPath.row]
            
            return cell
        }
            
        else if (tableView == foodsTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! foodTVC
            cell.foodNameLabel.text = foodNameArray[indexPath.row]
            return cell
        }
    
        return UITableViewCell()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{

            isSearching = false
            view.endEditing(true)
            foodsTableView.reloadData()
            businessNameTable.reloadData()
        }
        else {
            isSearching = true
            
//            let capitalizedFoodArray = foodNameArray.map { $0.capitalized}  Kelimenin ilk harfini büyük yapmak için
            
            searchedFoodNameArray = foodNameArray.filter { $0.lowercased() .prefix(searchText.count) == searchText.lowercased()}
            searchBusinessArray = businessNameArray.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
            getBusinessNameAccordinGLocation()

            foodsTableView.reloadData()
            businessNameTable.reloadData()
            
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == businessNameTable && searchBusinessArray.isEmpty == false{
            globalSelectedBusinessNameSearchVC = searchBusinessArray[indexPath.row]
            
            if globalSelectedBusinessNameSearchVC != ""{
                self.performSegue(withIdentifier: "searchToFoodDetails", sender: nil)
            }
        }
        else if tableView == foodsTableView && searchedFoodNameArray.isEmpty == false{
            
            if indexPath.row < searchedFoodNameArray.count{
            globalSelectedFoodNameSearchVC = searchedFoodNameArray[indexPath.row]
                
                if globalSelectedFoodNameSearchVC != ""{
                    performSegue(withIdentifier: "toListOfSearchedFoods", sender: nil)
                    
                }
            }
        }
        
  
}
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
