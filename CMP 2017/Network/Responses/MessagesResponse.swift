//
//  MessagesResponse.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 26/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class MessagesResponse : Mappable {
    var result : Array<Message>?
    var code : NSInteger?
    var message : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        message <- map["message"]
    }
}
