//
//  Friend.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 22/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord

class Friend : BaseEntity {
    // MARK: - Vars -
    var idFriend : NSInteger?
    var sender : String?
    var receiver : String?
    var createdAt : String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        idFriend <- map["idFriend"]
        sender <- map["sender"]
        receiver <- map["receiver"]
        createdAt <- map["createdAt"]
    }
    
    func insertFriend() {
        if !recordExists(id: idFriend!, entity: "CDFriend", field: "idFriend") {
            CDFriend.create(with: ["idFriend":idFriend!,"createdAt":createdAt!,"sender":sender!,"receiver":receiver!])
        }
    }
}
