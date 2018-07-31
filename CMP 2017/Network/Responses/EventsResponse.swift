//
//  EventsResponse.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class EventsResponse : Mappable {
    var result : Array<Event>?
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
