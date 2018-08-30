//
//  Message.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 26/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import NoChat
import ObjectMapper

class Message :  BaseEntity, NOCChatItem {
    func uniqueIdentifier() -> String {
        return id!
    }
    
    func type() -> String {
        return "Text"
    }
    
    override init() {
        super.init()
        
    }
    
    var id: String?
    var idNetworking : NSInteger?
    var sender : String?
    var receiver : String?
    var message : String?
    var status : String?
    var delivered : String?
    
    var msgId: String = UUID().uuidString
    var msgType: String = "Text"
    
    var senderId: String = ""
    var date: Date = Date()
    var text: String = ""
    
    var isOutgoing: Bool = true
    var deliveryStatus: MessageDeliveryStatus = .Idle
    
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        idNetworking <- map["idNetworking"]
        sender <- map["sender"]
        receiver <- map["receiver"]
        message <- map["message"]
        status <- map["status"]
        delivered <- map["delivered"]
        
        senderId = sender!
        text = message!
        isOutgoing = senderId == SessionHelper.instance.email
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if (object is Message) {
            let message = object as! Message
            return self.idNetworking == message.idNetworking
        }
        return false
    }
    
//    func insertEvent() {
//        if !recordExists(id: idNetworking!, entity: "CDDailyEvent", field: "id") {
//            CDDailyEvent.create(with: ["id":idDailyEvent!,"dailyEventDate":dailyEventDate!,"dailyEventDescription":dailyEventDescription!,"dailyEventPicture":dailyEventPicture!,"image":image!,"dailyEventName":dailyEventName!])
//        }
//    }
}
