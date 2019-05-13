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

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var summaryPreviewLabel: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCaptureSession()
        setupCornerView()
        setupButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setupCornerView(){
        cornerView.layer.cornerRadius = 10
        cornerView.layer.masksToBounds = true
        cornerView.layer.shadowOpacity = 0.4
        cornerView.layer.shadowColor = UIColor.black.cgColor
        cornerView.layer.shadowOffset = CGSize(width: 1, height: 1)
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
    
    func setupButton(){
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.masksToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.height / 2
        photoButton.layer.masksToBounds = true
    }
    
    func setSummaryPreviewText(text: String?){
        UIView.animate(withDuration: 0.5) {
            self.cornerView.alpha = 0.8
            self.summaryPreviewLabel.text = text
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        if let image = UIImage(data: imageData){
            previewImageView.image = image
            SOCR().getString(image: image) { (rawString) in
                self.setSummaryPreviewText(text: rawString)
            }
        }
        
    }
    
}

