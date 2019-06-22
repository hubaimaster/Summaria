//
//  ViewController.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import UIKit
import AVFoundation
import CropViewController


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var summaryPreviewLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.captureSession?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
                UIView.performWithoutAnimation {
                    self.setupLivePreview()
                }
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
            presentCropViewController(image: image)
        }
    }
    
    func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
}

extension CameraViewController: CropViewControllerDelegate, CameraViewDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.presentPopupView(image: image)
        }
    }
    
    func presentPopupView(image: UIImage) {
        SOCR().getString(image: image) { (text) in
            guard let text = text else {
                return
            }
            let alert = UIAlertController(title: "스캔됨", message: text, preferredStyle: UIAlertController.Style.actionSheet);
            alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { (action) in
                self.saveToEnd(text: text, image: image)
            }))
            // TODO
            alert.addAction(UIAlertAction(title: "복사", style: .default, handler: { (action) in
                self.saveToClipboard(text: text)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDocumentTitle(callback: @escaping (_ title: String)->Void) {
        let alert = UIAlertController(title: "문서 제목", message: nil, preferredStyle: .alert)
        var textField: UITextField?
        //alert.view = textField
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            if let documentTitle = textField?.text, documentTitle.count > 0{
                callback(documentTitle)
            }else{
                let documentTitle = "이름없음"
                callback(documentTitle)
            }
        }))
        alert.addTextField { (_textField) in
            textField = _textField
            _textField.placeholder = "문서 제목을 입력하세요"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToEnd(text: String, image: UIImage) {
        getDocumentTitle { (title) in
            self.save(text: text, image: image, documentTitle: title){
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func save(text: String, image: UIImage, documentTitle: String, callback: @escaping (()->Void)={}){
        guard let data = image.scaleImage(256)?.pngData() else {
            return
        }
        API.document.createDocument(title: documentTitle, text: text, image: data) { (documentModel) in
            callback()
        }
    }
    
    func saveToClipboard(text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol CameraViewDelegate {
    func saveToEnd(text: String, image: UIImage)
}
