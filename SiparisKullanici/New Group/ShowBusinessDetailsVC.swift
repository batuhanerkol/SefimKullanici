//
//  ShowBusinessDetailsVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import  Parse

 var globalSelectedTitleShowDetails1 = ""
 var globalYogunlukOraniShowDetails1 = ""

class ShowBusinessDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     var nameArray = [String]()
     var foodTitleArray = [String]()
     var imageArray = [PFFile]()
     var emailArray = [String]()
     var lezzetArray = [String]()
     var servisArray = [String]()
     var masaSayisiArray = [String]()
     var teslimEdilmeyenYemekSayisiArray = [String]()
    
    var mesaSayisi = ""
    var email = ""
    
      var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var yogunlukOranLabel: UILabel!
    @IBOutlet weak var lezzetNameLabel: UILabel!
    @IBOutlet weak var servisNameLabel: UILabel!
    @IBOutlet weak var servisPuanLAbel: UILabel!
    @IBOutlet weak var lezzetPuanLabel: UILabel!
    @IBOutlet weak var titleNameTable: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var businessLogoImage: UIImageView!
 

    override func viewDidLoad() {
        super.viewDidLoad()

        titleNameTable.delegate = self
        titleNameTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
    
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
            
            getBusinessDetails()
        case .wwan:
            
           getBusinessDetails()
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    
    func getBusinessDetails(){
        if globalSelectedBusinessNameAnaSayfaVC != "" && globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == "" {
            
            businessNameLabel.text = globalSelectedBusinessNameAnaSayfaVC
            
            getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameAnaSayfaVC)
            getFoodTitleData(IsletmeAdi: globalSelectedBusinessNameAnaSayfaVC)
            
        }
        else if globalFavBusinessNameFavorilerimVC != "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
            businessNameLabel.text = globalFavBusinessNameFavorilerimVC
            
            getBusinessLogo(IsletmeAdi: globalFavBusinessNameFavorilerimVC)
            getFoodTitleData(IsletmeAdi: globalFavBusinessNameFavorilerimVC)
        
            
        }
        else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC != "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
            businessNameLabel.text = globalSelectedBusinessNameSearchVC
            
            getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameSearchVC)
            getFoodTitleData(IsletmeAdi: globalSelectedBusinessNameSearchVC)
         
        }
        else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood != ""{
            
            
            businessNameLabel.text = globalSelectedBusinessNameListOfSearchedFood
            
            getBusinessLogo(IsletmeAdi: globalSelectedBusinessNameListOfSearchedFood)
            getFoodTitleData(IsletmeAdi: globalSelectedBusinessNameListOfSearchedFood)
     
        }
    }
    
    
    func getFoodTitleData(IsletmeAdi:String){
        
        let query = PFQuery(className: "FoodTitle")
        query.whereKey("BusinessName", equalTo: IsletmeAdi)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
               
                self.foodTitleArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.foodTitleArray.append(object.object(forKey: "foodTitle") as! String)
                }
            }
            
              self.titleNameTable.reloadData()
        }
    }
    
    
    func getBusinessLogo(IsletmeAdi:String){
        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: IsletmeAdi)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                
                self.imageArray.removeAll(keepingCapacity: false)
                 self.emailArray.removeAll(keepingCapacity: false)
                self.lezzetArray.removeAll(keepingCapacity: false)
                self.servisArray.removeAll(keepingCapacity: false)
                  self.masaSayisiArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    
                    self.imageArray.append(object.object(forKey: "image") as! PFFile)
                    self.emailArray.append(object.object(forKey: "businessUserName") as! String)
                    self.lezzetArray.append(object.object(forKey: "LezzetPuan") as! String)
                    self.servisArray.append(object.object(forKey: "HizmetPuan") as! String)
                     self.masaSayisiArray.append(object.object(forKey: "MasaSayisi") as! String)
                    
                    self.lezzetPuanLabel.text = "\(self.lezzetArray.last!)"
                    self.servisPuanLAbel.text = "\(self.servisArray.last!)"
                     self.email = "\(self.emailArray.last!)"
                    self.mesaSayisi = "\(self.masaSayisiArray.last!)"
                   
                    
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        else{
                            self.businessLogoImage.image = UIImage(data: (data)!)
                        }
                    })
                    
                }
                if Double(self.servisPuanLAbel.text!)! < 2.5{
                    self.servisPuanLAbel.backgroundColor = .orange
                    self.servisNameLabel.backgroundColor = .orange
                    if Double(self.servisPuanLAbel.text!)! < 1{
                        self.servisPuanLAbel.backgroundColor = .red
                        self.servisNameLabel.backgroundColor = .red
                    }
                }
                if Double(self.lezzetPuanLabel.text!)! < 2.5{
                    self.lezzetPuanLabel.backgroundColor = .orange
                    self.lezzetNameLabel.backgroundColor = .orange
                    if Double(self.lezzetPuanLabel.text!)! < 1{
                        self.lezzetPuanLabel.backgroundColor = .red
                        self.lezzetNameLabel.backgroundColor = .red
                    }
                }
            self.getBusinnesYogunlugu(IsletmeAdi: IsletmeAdi)
                
            }
        }
    }
    
    var doluMasaSayisi = 0
    var isletmeDolulukOrani = 0
    
    func getBusinnesYogunlugu(IsletmeAdi:String){
        let query = PFQuery(className: "VerilenSiparisler")
        query.whereKey("IsletmeAdi", equalTo: IsletmeAdi)
        query.whereKey("YemekTeslimEdildi", notEqualTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                self.teslimEdilmeyenYemekSayisiArray.removeAll(keepingCapacity: false)
                globalYogunlukOraniShowDetails1 = ""
                for object in objects!{
                    
                    self.teslimEdilmeyenYemekSayisiArray.append(object.object(forKey: "YemekTeslimEdildi") as! String)
                }
                print("YemekTeslimEdildi:", self.teslimEdilmeyenYemekSayisiArray)
                print("YemekTeslimEdildi:", self.teslimEdilmeyenYemekSayisiArray.count)
                print("masasayisi", self.mesaSayisi)
                
                self.doluMasaSayisi = Int(self.mesaSayisi)! - self.teslimEdilmeyenYemekSayisiArray.count
                print("self.doluMasaSayisi:", self.doluMasaSayisi)
                self.isletmeDolulukOrani = ((self.doluMasaSayisi * 100) / Int(self.mesaSayisi)!)
                print("self.isletmeDolulukOrani:",self.isletmeDolulukOrani)
                
                self.yogunlukOranLabel.text = "%\(String(self.isletmeDolulukOrani))"
                globalYogunlukOraniShowDetails1 = String(self.isletmeDolulukOrani)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                }
            }
        }
   
    
    @IBAction func addToFavButtonPressed(_ sender: Any) {
        let object = PFObject(className: "FavorilerListesi")
        
        object["IsletmeSahibi"] = email
        object["SiparisSahibi"] = PFUser.current()?.username!
        object["IsletmeAdi"] = businessNameLabel.text!
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        globalSelectedTitleShowDetails1 = (titleNameTable.cellForRow(at: indexPath)?.textLabel?.text)!
        
        self.performSegue(withIdentifier: "showDetails1To2", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  foodTitleArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        return cell
    }
    
    
    
    @IBAction func showBusinessLocaButtonPressed(_ sender: Any) {
    }
   
    
}
