//
//  AuthDAO.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 03/06/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation


class AWSIAuthDAO: AuthDAO{
    
    func guest(callback: @escaping (Bool) -> Void) {
        AWSI.instance.auth_guest { (resp) in
            if let resp = resp, !resp.keys.contains("error"){
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    func logout(callback: @escaping (Bool) -> Void) {
        AWSI.instance.auth_logout { (resp) in
            if let resp = resp, !resp.keys.contains("error"){
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
}
