//
//  API.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit


class API{
    
    static let auth = AWSIAuthDAO()
    static let document = AWSIDocumentDAO()
    static let documentSet = AWSIDocumentSetDAO()
    
}

protocol AuthDAO {
    func guest(callback: @escaping (Bool)->Void)
    func logout(callback: @escaping (Bool)->Void)
}

protocol DocumentSetDAO {
    func getMyDocumentSets(callback: @escaping ([DocumentSetModel]?)->Void)
    func createDocumentSet(callback: @escaping (DocumentSetModel?)->Void)
    func addDocument(documentSetId: String, documentId: String, callback: @escaping (Bool)->Void)
}

protocol DocumentDAO {
    func getDocument(id: String, callback: @escaping (DocumentModel?)->Void)
    func createDocument(title: String, text: String, callback: @escaping (DocumentModel)->Void)
    func deleteDocument(id: String, callback: @escaping (Bool)->Void)
}
