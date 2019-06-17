//
//  AuthDAO.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 03/06/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import SwiftyJSON
import FBSDKLoginKit


class AWSIAuthDAO: AuthDAO{
    
    private func getGuestId()->String?{
        return UserDefaults.standard.value(forKey: "guest_id") as? String
    }
    
    private func setGuestId(id: String?){
        UserDefaults.standard.set(id, forKey: "guest_id")
    }
    
    func guest(callback: @escaping (Bool) -> Void) {
        AWSI.instance.auth_guest(guest_id: getGuestId()) { (resp) in
            if let resp = resp, !resp.keys.contains("error"){
                let json = JSON(resp)
                if let id = json["guest_id"].string{
                    self.setGuestId(id: id)
                }
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    func facebook(callback: @escaping (Bool)->Void) {
        
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
