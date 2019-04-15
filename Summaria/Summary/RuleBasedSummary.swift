//
//  RuleBasedSummary.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation


class RuleBasedSummary: Summary{
    
    func getSummary(rawString: String, callback: @escaping (String?) -> Void) {
        callback("Summ:\(rawString)")
    }
    
}
