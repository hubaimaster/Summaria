//
//  DocumentDAO.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import SwiftyJSON


class AWSIDocumentDAO: DocumentDAO{
    
    func createDocument(title: String, text: String, image: Data, callback: @escaping (String?) -> Void) {
        var item = ["title": title, "text": text]
        let partition = "document"
        AWSI.instance.storage_upload_file(file_data: image, file_name: "image", read_groups: ["owner"], write_groups: ["owner"]) { (resp) in
            guard let data = resp else {
                return
            }
            let json = JSON(data)
            if let fileId = json["file_id"].string{
                item["file_id"] = fileId
            }
            AWSI.instance.database_create_item(item: item, partition: partition, read_groups: ["owner"], write_groups: ["owner"]) { (resp) in
                if let data = resp{
                    let json = JSON(data)
                    callback(json["item_id"].string)
                }else{
                    callback(nil)
                }
            }
        }
    }
    
    func deleteDocument(id: String, callback: @escaping (Bool) -> Void) {
        AWSI.instance.database_delete_item(item_id: id) { (resp) in
            if let _ = resp{
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    func getDocument(id: String, callback: @escaping (DocumentModel?) -> Void) {
        AWSI.instance.database_get_item(item_id: id) { (resp) in
            if let data = resp{
                let json = JSON(data)
                callback(DocumentModel(item: json["item"]))
            }else{
                callback(nil)
            }
        }
    }
    
    func getDocuments(callback: @escaping ([DocumentModel]?)->Void){
        AWSI.instance.database_get_items(partition: "document") { (resp) in
            if let data = resp{
                let json = JSON(data)
                if let items = json["items"].array{
                    let models = items.map({ (item) -> DocumentModel in
                        return DocumentModel(item: item)
                    })
                    callback(models)
                }else{
                    callback(nil)
                }
            }
        }
    }
}
