//
//  DocumentDAO.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation

class AWSIDocumentDAO: DocumentDAO{
    func createDocument(title: String, text: String, callback: @escaping (DocumentModel) -> Void) {
        
    }
    
    func deleteDocument(id: String, callback: @escaping (Bool) -> Void) {
        
    }
    
    func getDocument(id: String, callback: @escaping (DocumentModel?) -> Void) {
        AWSI.instance.database_get_item(item_id: id) { (resp) in
            
        }
    }
}
