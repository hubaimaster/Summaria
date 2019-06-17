//
//  DocumentModel.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import SwiftyJSON


class DocumentModel: ModelBase{
    var title: String?
    var text: String?
    var date: Double?
    var imageFileId: String?
    var image: UIImage?
    
    init(item: JSON) {
        super.init()
        self.id = item["id"].string
        self.title = item["title"].string
        self.text = item["text"].string
        self.date = item["creation_date"].double
        self.imageFileId = item["file_id"].string
    }
}
