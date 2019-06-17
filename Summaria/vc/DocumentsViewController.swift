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
    var models: [ModelBase] = []
    
    func setup(){
        // 게스트 로그인 후에 도큐먼트 모델을 로드
        API.auth.guest { (success) in
            self.loadDocumentModels()
        }
    }
    
    func loadDocumentModels(){
        API.document.getDocuments { (documents) in
            guard let documents = documents else{
                return
            }
            for document in documents{
                self.appendDocument(model: document)
            }
        }
    }
    
    func appendDocument(model: DocumentModel){
        let indexPath = IndexPath(item: models.count, section: 0)
        if self.models.contains(model) == false{
            self.models.append(model)
            DispatchQueue.main.sync {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func removeDocument(model: DocumentModel){
        if let item = models.index(of: model){
           let indexPath = IndexPath(item: item, section: 0)
            self.models.remove(at: item)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func reloadView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
                        self.removeDocument(model: model)
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
