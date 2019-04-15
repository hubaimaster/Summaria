//
//  ImageToString.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit


protocol OCR {
    func getString(image: UIImage, callback: @escaping (String?)->Void)
}
