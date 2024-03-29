//
//  SelectFood1VC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 15.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

var globalSelectecTitleSelectFood1 = ""

class SelectFood1VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var nameArray = [String]()
    var foodTitleArray = [String]()
    var tableNumberArray = [String]()
    var imageArray = [PFFile]()
    var testeArray = [String]()
    var serviceArray = [String]()
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var lezzetNameLabel: UILabel!
    @IBOutlet weak var servisNameLabel: UILabel!
    @IBOutlet weak var lezzetLabel: UILabel!
    @IBOutlet weak var hizmetLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var businessLogoImage: UIImageView!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var foodTitleTable: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        //internet bağlantı kontrolü
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        foodTitleTable.delegate = self
        foodTitleTable.dataSource = self
      
        tableNumberLabel.text = globalTableNumberEnterNumberVC
        
        navigationItem.hidesBackButton = true
        
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
            
            getFoodTitleData()
            getBussinessNameData()
            
        case .wwan:
            
            getFoodTitleData()
            getBussinessNameData()
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func getBussinessNameData(){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessUserName", equalTo: globalBussinessEmailQRScannerVC)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.nameArray.removeAll(keepingCapacity: false)
                self.serviceArray.removeAll(keepingCapacity: false)
                self.testeArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    self.nameArray.append(object.object(forKey: "businessName") as! String)
                    self.serviceArray.append(object.object(forKey: "HizmetPuan") as! String)
                    self.testeArray.append(object.object(forKey: "LezzetPuan") as! String)

                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            self.businessLogoImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                    self.hizmetLabel.text = "\(self.serviceArray.last!)"
                     self.lezzetLabel.text = "\(self.testeArray.last!)"
                    self.businessNameLabel.text = "\(self.nameArray.last!)"
                }
              
                if Double(self.hizmetLabel.text!)! < 2.5{
                    self.hizmetLabel.backgroundColor = .orange
                    self.servisNameLabel.backgroundColor = .orange
                     if Double(self.hizmetLabel.text!)! < 1{
                        self.hizmetLabel.backgroundColor = .red
                        self.servisNameLabel.backgroundColor = .red
                    }
                }
                if Double(self.lezzetLabel.text!)! < 2.5{
                    self.lezzetLabel.backgroundColor = .orange
                    self.lezzetNameLabel.backgroundColor = .orange
                    if Double(self.lezzetLabel.text!)! < 1{
                        self.lezzetLabel.backgroundColor = .red
                         self.lezzetNameLabel.backgroundColor = .red
                    }
                }
            }
        }
    }

    func getFoodTitleData(){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("foodTitleOwner", equalTo: globalBussinessEmailQRScannerVC)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
       
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.foodTitleArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                 
                }
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.foodTitleTable.reloadData()
               
            }
        }
        
    }

    @IBAction func showLocationButtonPressed(_ sender: Any) {
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        globalSelectecTitleSelectFood1 = (foodTitleTable.cellForRow(at: indexPath)?.textLabel?.text)!
        
        self.performSegue(withIdentifier: "selectFood1ToSelectFood2", sender: nil)

    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = foodTitleArray[sourceIndexPath.row]
        foodTitleArray.remove(at: sourceIndexPath.row)
        foodTitleArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = foodTitleArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        return cell
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        
        let object = PFObject(className: "FavorilerListesi")
        
            object["IsletmeSahibi"] = globalBussinessEmailQRScannerVC
            object["SiparisSahibi"] = PFUser.current()?.username!
            object["IsletmeAdi"] = globalBusinessNameEnterNumberVC
            
            object.saveInBackground { (success, error) in
                if error != nil{
                    let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else{
                    let alert = UIAlertController(title: "Favorilere Eklendi", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    
                }
    
    
}
