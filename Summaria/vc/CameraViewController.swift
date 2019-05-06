//
//  ViewController.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var captureButtonView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCaptureSession()
        setupCaptureButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func setupCaptureButton(){
        captureButton.layer.cornerRadius = captureButton.frame.height / 2
        captureButton.layer.masksToBounds = true
        captureButtonView.layer.cornerRadius = captureButtonView.frame.height / 2
        captureButtonView.layer.masksToBounds = false
        captureButtonView.layer.shadowOpacity = 0.2
        captureButtonView.layer.shadowOffset = CGSize(width: 1, height: 1)
        captureButtonView.layer.shadowRadius = 5.0
    }
    
    func setupCaptureSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewImageView.layer.addSublayer(videoPreviewLayer)
        previewImageView.contentMode = .scaleAspectFill
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewImageView.bounds
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        if let image = UIImage(data: imageData){
            previewImageView.image = image
            SOCR().getString(image: image) { (rawString) in
                print(rawString)
                RuleBasedSummary().getSummary(rawString: rawString!) { (summary) in
                    print(summary)
                    
                }
            }
        }
        
    }
    
}

