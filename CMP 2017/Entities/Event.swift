//
//  File.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord

class Event : BaseEntity {
    
    // MARK: - Vars -
    var idEvent : NSInteger?
    var name : String?
    var eventDescription : String?
    var image : String?
    var eventDate : String?
    var eventHour : String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        idEvent <- map["idEvent"]
        name <- map["name"]
        eventDescription <- map["description"]
        image <- map["image"]
        eventDate <- map["eventDate"]
        eventHour <- map["eventHour"]
    }
    
    func insertEvent() {
        if !recordExists(id: self.idEvent!, entity: "CDEvent", field: "idEvent") {
            CDEvent.create(with: ["idEvent":self.idEvent!,"eventDate":self.eventDate!,"eventDescription":self.eventDescription!,"eventHour":self.eventHour!,"image":self.image!,"name":self.name!])
        }
    }
}
