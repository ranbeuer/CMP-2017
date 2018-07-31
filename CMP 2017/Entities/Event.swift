//
//  File.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class Event : Mappable {
    
    // MARK: - Vars -
    var idEvent : NSInteger?
    var name : String?
    var eventDescription : String?
    var image : String?
    var eventDate : String?
    var eventHour : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        idEvent <- map["idEvent"]
        name <- map["name"]
        eventDescription <- map["description"]
        image <- map["image"]
        eventDate <- map["eventDate"]
        eventHour <- map["eventHour"]
    }
}
