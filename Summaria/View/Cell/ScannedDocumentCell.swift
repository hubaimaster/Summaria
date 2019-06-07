//
//  ScannedDocumentCell.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit


class Cache {
    
    static let instance = Cache()
    private init(){}
    
    private var dict: [String: Any] = [:]
    func set(key: String, object: Any?) {
        dict[key] = object
    }
    
    func get(key: String) -> Any? {
        return dict[key]
    }
}


class ScannedDocumentCell: UITableViewCell {
    var model: DocumentModel?{
        didSet{
            setup()
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup(){
        if let model = model{
            setupDate(model)
            setupTitle(model)
            setupCount(model)
            setupThumbnail(model)
        }
    }
    
    func setupDate(_ model: DocumentModel){
        if let dateDobule = model.date{
            let date = Date(timeIntervalSince1970: dateDobule)
            let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
            dateLabel.text = dateString
        }
    }
    
    func setupTitle(_ model: DocumentModel){
        titleLabel.text = model.title
    }
    
    func setupCount(_ model: DocumentModel){
        //countLabel.text = nil
    }
    
    func setupThumbnail(_ model: DocumentModel){
        self.thumbnail.layer.cornerRadius = 10
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.contentMode = .scaleAspectFill
        self.thumbnail.image = model.image
    }
    
}
