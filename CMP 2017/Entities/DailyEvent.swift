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

class DailyEvent : BaseEntity {
    var idDailyEvent : NSInteger?
    var dailyEventName : String?
    var dailyEventDescription : String?
    var image : String?
    var dailyEventDate : String?
    var dailyEventStartsAt : String?
    var dailyEventPicture : String?
    
    
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
        if !recordExists(id: idDailyEvent!, entity: "CDDailyEvent", field: "id") {
            CDDailyEvent.create(with: ["id":idDailyEvent!,"dailyEventDate":dailyEventDate!,"dailyEventDescription":dailyEventDescription!,"dailyEventPicture":dailyEventPicture!,"image":image!,"dailyEventName":dailyEventName!])
        }
    }
}
