//
//  Exhibitor.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord

class Exhibitor : BaseEntity {
    
    // MARK: - Vars -
    var idExhibitor : NSInteger?
    var name : String?
    var email : String?
    var lastName : String?
    var phonenumber : String?
    var degree : String?
    var history : String?
    var picture : String?
    var job : String?
    var url : String?
    var type : NSInteger?
    
    
    required init?(map: Map){
        super.init(map: map)
        
    }
    
    override func mapping(map: Map) {
        idExhibitor <- map["idExhibitor"]
        name <- map["name"]
        email <- map["email"]
        lastName <- map["imlastNameage"]
        phonenumber <- map["degree"]
        degree <- map["degree"]
        history <- map["history"]
        picture <- map["picture"]
        job <- map["job"]
        url <- map["url"]
        type <- map["type"]
    }
    
    func insertExhibitor() {
        if !recordExists(id: idExhibitor!, entity: "CDExhibitor", field: "idExhibitor") {
            CDExhibitor.create(with: ["idExhibitor":idExhibitor!,"degree":degree!,"email":email!,"history":history!,"job":job!,"lastName":lastName ?? "", "name":name!, "phoneNumber":phonenumber!, "url":picture!, "type":type!])
        }
    }
}
