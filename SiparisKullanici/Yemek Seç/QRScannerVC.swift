//
//  QRScannerVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import Parse

var globalBussinessEmailQRScannerVC : String = ""

class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var square: UIImageView!
    // Uygulama kendi kendine 4 kere segue yapıyor boolValue kullanarak tek seferde hallediyoruz.
    var tekrarsiz = false
    
    let locationManager = CLLocationManager()
    
    var longiduteDouble: Double = 0
    var latitudeDouble: Double = 0
    
    var kontroArray = [String]()
    
    var businessMailArray = [String]()

var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
          updateUserInterface()
        
        globalSelectedBusinessNameAnaSayfa = ""
        globalFavBusinessNameFavorilerimVC = ""
        globalBussinessEmailQRScannerVC = ""
        globalSelectedBusinessNameSearchVC = ""
        globalSelectedBusinessNameListOfSearchedFood = ""
        globalTableNumberEnterNumberVC = ""
        globalBusinessNameEnterNumberVC = ""
        
        //lokasyon
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        { 
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
            
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(square)
        session.startRunning()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        globalBussinessEmailQRScannerVC = ""
        tekrarsiz = true
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
            
            print("WifiConnection")
         
        case .wwan:
            print("wwanConnection")
        
        }
        //        print("Reachability Summary")
        //        print("Status:", status)
        //        print("HostName:", Network.reachability?.hostname ?? "nil")
        //        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        //        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
   
 
    func getBusinessNamesWhichIsNear(){
        
        let query = PFQuery(className: "BusinessInformation")
//        query.whereKey("Lokasyon", nearGeoPoint: PFGeoPoint(latitude: self.latitudeDouble, longitude:  self.longiduteDouble), withinKilometers: 0.5)
        query.whereKey("HesapOnaylandi", equalTo: "Evet")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.businessMailArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.businessMailArray.append(object.object(forKey: "businessUserName") as! String)
                }
                
                if self.businessMailArray.contains(globalBussinessEmailQRScannerVC){
                    
                             self.locationManager.stopUpdatingLocation()
                    self.performSegue(withIdentifier: "QRCodeToEnterNumber", sender: nil)
                }
                else{
                    let alert = UIAlertController(title: "Sipariş Verebilmek İçin İşletmenin İçinde Olmalısınız :)", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
               
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        globalCurrentLocationLatSearchVC = locValue.latitude
        globalCurrentLocationLongSearchVC = locValue.longitude
        self.longiduteDouble = locValue.longitude
        self.latitudeDouble = locValue.latitude
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr && tekrarsiz == true
                {
                    globalBussinessEmailQRScannerVC = object.stringValue!
                    tekrarsiz = false

                    self.getBusinessNamesWhichIsNear()

                    
                }
            }
        }
    }
    
    
    }


