//
//  ViewController.swift
//  QR Scanner
//
//  Created by MYERS, CLAIRE on 10/17/17.
//  Copyright © 2017 District196. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    @IBOutlet weak var ConfirmationMessage: UILabel!
    @IBOutlet weak var Banner: UILabel!
    

    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //creating session
        let session = AVCaptureSession()
        
        //define capture device
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch
        {
           print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: ConfirmationMessage)
        self.view.bringSubview(toFront: Banner)
        
        session.startRunning()
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    var message = "\(object.stringValue)"
                    var firstHalf = message.dropFirst(10)
                    let finalString = firstHalf.dropLast(2)
                    /*let alert = UIAlertController(title: "QR CODE", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {(nil) in
                        UIPasteboard.general.string = object.stringValue}))
                    
                    present(alert, animated: true, completion: nil) */
                    ConfirmationMessage.text = " Student \(finalString) has checked in!"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

