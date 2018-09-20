//
//  DailyEvent.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/30/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord
import CoreData

class DailyEvent : BaseEntity {
    var idDailyEvent : NSInteger?
    var dailyEventName : String?
    var dailyEventDescription : String?
    var image : String?
    var dailyEventDate : String?
    var dailyEventStartsAt : String?
    var dailyEventPicture : String?
    var likes : NSInteger = 0
    var isSocial : Bool = false
    
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        idDailyEvent <- map["idDailyEvent"]
        dailyEventName <- map["dailyEventName"]
        dailyEventDescription <- map["dailyEventDescription"]
        image <- map["image"]
        dailyEventDate <- map["dailyEventDate"]
        dailyEventStartsAt <- map["dailyEventStartsAt"]
        dailyEventPicture <- map["dailyEventPicture"]
    }
    
    func insertEvent() {
        if !eventExists(id: self.idDailyEvent!, isSocial: self.isSocial) {
            CDDailyEvent.create(with: ["id":idDailyEvent!,"dailyEventDate":dailyEventDate!,"dailyEventDescription":dailyEventDescription!,"dailyEventPicture":dailyEventPicture!,"image":image!,"dailyEventName":dailyEventName!, "isSocial" : isSocial, "likes" : likes])
        }
    }
    
    func eventExists(id: NSInteger, isSocial: Bool) -> Bool {
        let query = String(format:"id = %d AND isSocial = \(String(isSocial))", id )
        return super.recordExists(query: query, entity: "CDDailyEvent")
    }
}
