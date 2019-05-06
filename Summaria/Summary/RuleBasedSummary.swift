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
        // TODO: Tommy
        // Input rawString from parameter and get summary form rawString
        // and return summaryString via callback function
        // I.E
        var summaryString = createSummary(input: rawString)
        callback(summaryString)
    }
    
    func createSummary(input: String) -> String {
        var output = input
        
        return output
    }
    
}
