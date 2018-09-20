//
//  EventExhibitorRelation.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 10/09/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord

class EventExhibitorRelation :  BaseEntity {
    var idEventExhibitor : Int?
    var idEvent : Int?
    var idExhibitor : Int?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        idEventExhibitor <- map["idEventExhibitor"]
        idEvent <- map["idEvent"]
        idExhibitor <- map["idExhibitor"]
    }
    
    func insertRelation() {
        if !recordExists(id: idEventExhibitor!, entity: "CDEvExRelation", field: "idEventExhibitor") {
            CDEvExRelation.create(with: ["idEventExhibitor":idEventExhibitor!,"idEvent":idEvent!,"idExhibitor":idExhibitor!])
        }
    }
}
