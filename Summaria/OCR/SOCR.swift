//
//  SOCR.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class SOCR: OCR {
    
    func getString(image: UIImage, callback: @escaping (String?)->Void){
        guard let image = image.scaleImage(512), let imageBase64 = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            return
        }
        let apiKey = API_KEY
        let baseUrl = "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
        let params = ["requests": [
                "image": ["content": "\(imageBase64)"],
                "features": [
                    ["type": "DOCUMENT_TEXT_DETECTION"]
                ]
            ]
        ]
        Alamofire.request(baseUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { (resp) in
            if let error = resp.error{
                print("ERROR:[\(error)]")
            }else if let data = resp.data{
                if let json = try? JSON(data: data), let responses = json["responses"].array{
                    for response in responses{
                        let text = response["fullTextAnnotation"]["text"].string
                        callback(text)
                    }
                }
            }
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
