//
//  SOCR.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit
import SwiftyTesseract


class SOCR: OCR {
    
    let swiftyTesseract = SwiftyTesseract(language: .english)
    
    func getString(image: UIImage, callback: @escaping (String?)->Void){
        guard let image = image.scaleImage(320) else {
            return
        }
        swiftyTesseract.whiteList = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        swiftyTesseract.performOCR(on: image) { recognizedString in
            guard let recognizedString = recognizedString else { return }
            callback(recognizedString)
        }
    }
}

extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
