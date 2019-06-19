//
//  ModelBase.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation


class ModelBase: Equatable {
    var id: String?
    
    static func == (lhs: ModelBase, rhs: ModelBase) -> Bool {
        if let lid = lhs.id, let rid = rhs.id{
            return lid == rid
        }else{
            return false
        }
    }
    
}
