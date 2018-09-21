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
    var likes : NSInteger = 0
    var isSocial : Bool = false
    
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
        if (idEvent == nil) {
            idEvent <- map["idEventSocial"]
            isSocial = true
        }
    }
    
    func insertEvent() {
        print("Event id: \(self.idEvent!)")
        if !eventExists(id: self.idEvent!, isSocial: self.isSocial) {
            CDEvent.create(with: ["idEvent":self.idEvent!,"eventDate":self.eventDate!,"eventDescription":self.eventDescription!,"eventHour":self.eventHour!,"image":self.image!,"name":self.name!, "isSocial" : self.isSocial, "likes" : self.likes])
            
        }
    }
    
    func eventExists(id: NSInteger, isSocial: Bool) -> Bool {
        let query = String(format:"idEvent = %d AND isSocial = \(String(isSocial))", id)
        return super.recordExists(query: query, entity: "CDEvent")
    }
}
