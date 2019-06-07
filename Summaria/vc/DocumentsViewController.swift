//
//  DocumentsViewController.swift
//  Summaria
//
//  Created by kchdully on 07/06/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit


class DocumentsViewController: UITableViewController{
    
    static var instance: DocumentsViewController?
    var models: [Any] = []
    
    func setup(){
        API.auth.guest { (success) in
            self.loadDocumentModels()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.reloadView()
        })
    }
    
    func loadDocumentModels(){
        API.document.getDocuments { (documents) in
            guard let documents = documents else{
                self.reloadView()
                return
            }
            self.models.removeAll()
            for document in documents{
                self.setImage(documentModel: document, callback: {
                    self.models.append(document)
                    if self.models.count == documents.count{
                        self.reloadView()
                    }
                })
            }
        }
    }
    
    func reloadView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setImage(documentModel: DocumentModel, callback: @escaping ()->Void){
        guard let file_id = documentModel.imageFileId else {
            documentModel.image = nil
            callback()
            return
        }
        if let image = Cache.instance.get(key: file_id) as? UIImage{
            documentModel.image = image
            callback()
        }else{
            AWSI.instance.storage_download_file(_file_id: file_id) { (data) in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    Cache.instance.set(key: file_id, object: image)
                    documentModel.image = image
                    callback()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        DocumentsViewController.instance = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        DocumentsViewController.instance = self
        super.viewDidAppear(animated)
        setup()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        if let model = models[index] as? DocumentModel{
            let cell = tableView.dequeueReusableCell(withIdentifier: Config.cell.ScannedDocumentCell, for: indexPath) as! ScannedDocumentCell
            cell.model = model
            return cell
        }else{
            assert(false)
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        if let model = models[index] as? DocumentModel, let text = model.text{
            let alert = UIAlertController(title: "스캔됨", message: text, preferredStyle: UIAlertController.Style.actionSheet);
            alert.addAction(UIAlertAction(title: "클립보드에 복사", style: .default, handler: { (action) in
                UIPasteboard.general.string = text
            }))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
                if let id = model.id{
                    API.document.deleteDocument(id: id, callback: { (_) in
                        self.loadDocumentModels()
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
