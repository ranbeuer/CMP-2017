//
//  FriendsResponse.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 22/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class FriendsResponse : Mappable {
    var friends : Array<Friend>?
    var code : NSInteger?
    var message : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        friends <- map["response.friends"]
        code <- map["code"]
        message <- map["message"]
    }
}
