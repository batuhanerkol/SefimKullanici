//
//  QRScannerVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import AVFoundation


var globalBussinessEmailQRScannerVC : String = ""

class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var square: UIImageView!
    // Uygulama kendi kendine 4 kere segue yapıyor boolValue kullanarak tek seferde hallediyoruz.
    var tekrarsiz = false

var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        
           NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
          updateUserInterface()
        
        globalSelectedBusinessNameAnaSayfa = ""
        globalFavBusinessNameFavorilerimVC = ""
        globalBussinessEmailQRScannerVC = ""
        globalSelectedBusinessNameSearchVC = ""
        globalSelectedBusinessNameListOfSearchedFood = ""
        globalTableNumberEnterNumberVC = ""
        globalBusinessNameEnterNumberVC = ""
        
        super.viewDidLoad()
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
   
    override func viewWillAppear(_ animated: Bool) {
        tekrarsiz = true
        updateUserInterface()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr && tekrarsiz == true
                {
                           self.performSegue(withIdentifier: "QRCodeToEnterNumber", sender: nil)

                    globalBussinessEmailQRScannerVC = object.stringValue!
                    
                    tekrarsiz = false
                    
                }
            }
        }
    }
    }


