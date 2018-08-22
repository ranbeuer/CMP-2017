//
//  Friend.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 22/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class Friend : Mappable {
    // MARK: - Vars -
    var idFriend : NSInteger?
    var sender : String?
    var receiver : String?
    var createdAt : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        idFriend <- map["idFriend"]
        sender <- map["sender"]
        receiver <- map["receiver"]
        createdAt <- map["createdAt"]
    }
}
