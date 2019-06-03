//
//  ScannedDocumentCell.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit

class ScannedDocumentCell: UITableViewCell {
    
    var model: DocumentSetModel?{
        didSet{
            self.setup()
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup(){
        
    }
    
}
