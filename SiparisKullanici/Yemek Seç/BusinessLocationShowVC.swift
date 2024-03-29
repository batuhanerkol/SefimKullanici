//
//  BusinessLocationShowVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 23.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import MapKit
import Parse

class BusinessLocationShowVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var selectedName = ""
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    var chosenbusinessArray = [String]()
    var chosenLatitudeArray = [String]()
    var chosenLongitudeArray = [String]()
    
    var manager = CLLocationManager()
    var requestCLLocation = CLLocation()
    
    @IBOutlet weak var mapVC: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapVC.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        print("globalBussinessEmailQRScannerVC:",globalBussinessEmailQRScannerVC)
        print("globalFavBusinessNameFavorilerimVC:",globalFavBusinessNameFavorilerimVC)
        print("globalSelectedBusinessNameAnaSayfaVC:",globalSelectedBusinessNameAnaSayfaVC)
        print("globalSelectedBusinessNameSearchVC:",globalSelectedBusinessNameSearchVC)
        print("globalSelectedBusinessNameListOfSearchedFood:",globalSelectedBusinessNameListOfSearchedFood)
        
        if globalBussinessEmailQRScannerVC != "" && globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
             selectedName = ""
             chosenLatitude = ""
             chosenLongitude = ""
            
             chosenbusinessArray.removeAll()
             chosenLatitudeArray.removeAll()
             chosenLongitudeArray.removeAll()
            
            getLocationData()
            
        }else if globalFavBusinessNameFavorilerimVC != "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
            
        getLocationWithBusinessName(businessName: globalFavBusinessNameFavorilerimVC)
           
        }else if globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC != "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood == ""{
            
    
            
            getLocationWithBusinessName(businessName: globalSelectedBusinessNameAnaSayfaVC)
            
            
        }else if  globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC != "" && globalSelectedBusinessNameListOfSearchedFood == ""{
           
       
            
            getLocationWithBusinessName(businessName: globalSelectedBusinessNameSearchVC)
            
        }else if  globalFavBusinessNameFavorilerimVC == "" && globalSelectedBusinessNameAnaSayfaVC == "" && globalSelectedBusinessNameSearchVC == "" && globalSelectedBusinessNameListOfSearchedFood != ""{
            
       
            getLocationWithBusinessName(businessName: globalSelectedBusinessNameListOfSearchedFood)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
       
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.chosenLongitude != "" && self.chosenLatitude != ""{
            let location = CLLocationCoordinate2D(latitude: Double(self.chosenLatitude)!, longitude: Double(self.chosenLongitude)!)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.mapVC.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.chosenbusinessArray.last
            self.mapVC.addAnnotation(annotation)
            self.manager.stopUpdatingLocation()
        }
        self.manager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type:  .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != "" && self.chosenLongitude != "" {
            self.requestCLLocation = CLLocation(latitude: Double(self.chosenLatitude)!, longitude: Double(self.chosenLongitude)!)
            
            CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error)in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.chosenbusinessArray.last!
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions : launchOptions)
                    }
                }
            }
        }
    }
    func getLocationData(){
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
                self.chosenLatitudeArray.removeAll(keepingCapacity: false)
                self.chosenLongitudeArray.removeAll(keepingCapacity: false)
                self.chosenbusinessArray.removeAll(keepingCapacity: false)
                
                for object in objects!{
                    self.chosenLatitudeArray.append(object.object(forKey: "latitude") as! String)
                    self.chosenLongitudeArray.append(object.object(forKey: "longitude") as! String)
                    self.chosenbusinessArray.append(object.object(forKey: "businessName") as! String)
                    
                    
                    self.chosenLatitude = self.chosenLatitudeArray.last!
                    self.chosenLongitude = self.chosenLongitudeArray.last!
                    self.selectedName = self.chosenbusinessArray.last!
  
                    self.manager.startUpdatingLocation()
                }
          
            }
        }
        
    }
    
    func getLocationWithBusinessName(businessName:String){
    

        let query = PFQuery(className: "BusinessInformation")
        query.whereKey("businessName", equalTo: businessName)
         query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.chosenLatitudeArray.removeAll(keepingCapacity: false)
                self.chosenLongitudeArray.removeAll(keepingCapacity: false)
                self.chosenbusinessArray.removeAll(keepingCapacity: false)
                
                self.selectedName = ""
                 self.chosenLatitude = ""
                 self.chosenLongitude = ""
                
                for object in objects!{
                    self.chosenLatitudeArray.append(object.object(forKey: "latitude") as! String)
                    self.chosenLongitudeArray.append(object.object(forKey: "longitude") as! String)
                    self.chosenbusinessArray.append(object.object(forKey: "businessName") as! String)
                    
                    self.chosenLatitude = self.chosenLatitudeArray.last!
                    self.chosenLongitude = self.chosenLongitudeArray.last!
                    self.selectedName = self.chosenbusinessArray.last!

                    self.manager.startUpdatingLocation()
                }
            }
        }
        
    }
}
