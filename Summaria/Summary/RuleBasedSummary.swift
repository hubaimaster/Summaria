//
//  RuleBasedSummary.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 15/04/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import Reductio


class RuleBasedSummary: Summary{
    let compRate: Float = 0.80
    
    func getSummary(rawString: String, callback: @escaping (String) -> Void) {
        // TODO: Tommy
        // Input rawString from parameter and get summary form rawString
        // and return summaryString via callback function
        // I.E
        createSummary(input: rawString, callback: callback)
    }
    
    func createSummary(input: String, callback: @escaping (String)->Void) {
        Reductio.summarize(text: input, compression: compRate) { (phrases) in
            var output = ""
            for p in phrases{
                output += "\(p)\n"
            }
            callback(output)
        }
    }
    
}
