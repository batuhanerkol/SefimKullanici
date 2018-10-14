//
//  QRScannerVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 14.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import AVFoundation

var globalStringValue : String = ""
class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var square: UIImageView!
    
var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = AVCaptureSession()
        
        //Define capture devcie
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
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                           self.performSegue(withIdentifier: "QRCodeToEnterNumber", sender: nil)
                    print(object.stringValue)
                    globalStringValue = object.stringValue!
//
//                                        let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//                                        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
//                                            UIPasteboard.general.string = object.stringValue
//                                        }))
//                                        present(alert, animated: true, completion: nil)
//
                }
            }
        }
    }
    }


