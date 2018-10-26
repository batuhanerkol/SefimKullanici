//
//  SearchVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 22.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class SearchVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var offerTableView: UITableView!
    
    var businessNameArray = [String]()
    var searchBusinessArray = [String]()
    
    var foodNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        searchBar.delegate = self
      
    }
    override func viewWillAppear(_ animated: Bool) {
        getBussinessNameData()
        getFoodNameData()
    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "Locations")
      
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
            self.restaurantsTableView.reloadData()
            
        }
        print(businessNameArray)
    }
    
    func getFoodNameData(){
        let query = PFQuery(className: "FoodInformation")
        
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
            self.foodsTableView.reloadData()
            
        }
        print(foodNameArray)
    }
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//
//    }
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnNumber = 0
        
        if (tableView == restaurantsTableView){
            return businessNameArray.count
            returnNumber = businessNameArray.count
        }
        else if (tableView == foodsTableView){
            return foodNameArray.count
              returnNumber = foodNameArray.count
        }
        return returnNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        
        if tableView == restaurantsTableView,  let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as? RestaurantsTVC{
       
        cell.businessNameLabel.text = businessNameArray[indexPath.row]
      
        return cell
        }
        
        else if tableView == foodsTableView,  let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? foodTVC{
            
            cell.foodNameLabel.text = foodNameArray[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
