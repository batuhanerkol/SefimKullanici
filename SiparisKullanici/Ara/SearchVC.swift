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

    
    var businessNameArray = [String]()
    var searchBusinessArray = [String]()
    
    var foodNameArray:Set = [""]
    var searchedFoodNameArray = [String]()
    
    var testePointArray = [String]()
    
    var isSearching = false
    
    let locationManager = CLLocationManager()
    
    var longiduteDouble: Double = 0
    var latitudeDouble: Double = 0
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // internet kontrolü
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        businessNameTable.delegate = self
        businessNameTable.dataSource = self
        
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
        //lokasyon
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
      
        // loading sembolu
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        globalSelectedBusinessNameAnaSayfaVC = ""
        globalFavBusinessNameFavorilerimVC = ""
        globalSelectedBusinessNameSearchVC = ""
        globalSelectedBusinessNameListOfSearchedFood = ""
        
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
            getBussinessNameData()
            getFoodNameData()

        case .wwan:
            getBussinessNameData()
            getFoodNameData()

        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    // kullanıcı muvcut lokasyonu
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
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
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
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
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
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        query.whereKey("MenudeGorunsun", equalTo: "Evet")
       
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
                    self.foodNameArray.insert(object.object(forKey: "foodName") as! String)
                }
               
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            print("FoodName:", self.foodNameArray)
            self.foodsTableView.reloadData()
           self.locationManager.stopUpdatingLocation()
            
            
            let oneObjectArray:NSMutableArray = NSMutableArray() // array de sadece 1 yemek başlığını tutmak için
            
            for  object1 in self.foodNameArray{
                if oneObjectArray.contains(object1){
                    oneObjectArray.add(object1)
                }
            }
            print("oneObjectArray:", oneObjectArray)
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
                
                let query = PFQuery(className: "BusinessInformation")
                query.whereKey("businessName", equalTo: searchBusinessArray[indexPath.row])
                 query.whereKey("HesapOnaylandi", equalTo: "Evet")
                
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
                        if Double(cell.pointsLabel.text!)! < 2.5{
                            cell.pointsLabel.backgroundColor = .orange
                            
                            if Double(cell.pointsLabel.text!)! < 1{
                                cell.pointsLabel.backgroundColor = .red
                            }
                        }
                    }
                }
             
            }
                
            else{
                cell.businessNameLabel.text = "Henüz Arama Yapmadınız"
                cell.testePointLabel.text = ""
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
