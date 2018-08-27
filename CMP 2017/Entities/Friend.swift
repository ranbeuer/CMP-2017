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
    var idAvatar: Int? = 0
    var email: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var avatarImg: String? = ""
    var needsUpdate: Bool = false
    
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
            CDFriend.create(with: ["idFriend":idFriend!,"createdAt":createdAt!,"sender":sender!,"receiver":receiver!, "email":email!, "avatarImage":avatarImg!,"lastName":lastName!, "firstName":firstName!, "idAvatar": idAvatar!])
        } else {
            updateDBData()
        }
    }
    
    func updateDBData() { //should call save or saveAndWait after this call
        let cdFriend = getCDEquivalent(id: idFriend!, entity: "CDFriend", field: "idFriend") as! CDFriend
        
        if (cdFriend.email == "") {
            cdFriend.email = self.email!
            cdFriend.firstName = self.firstName!
            cdFriend.lastName = self.lastName!
            cdFriend.avatarImage = self.avatarImg!
            cdFriend.idAvatar = Int32(self.idAvatar!)
        }
    }
    
    func updateData(info: [String: Any?]) {
        idAvatar = (info["idAvatar"] as! Int)
        firstName = (info["name"] as! String)
        lastName = (info["lastname"] as! String)
        email = (info["email"] as! String)
        avatarImg = (info["avatar"] as! String)
    }
    
    func existsFriendAndNeedsUpdate() -> Bool {
        let cdFriend = getCDEquivalent(id: idFriend!, entity: "CDFriend", field: "idFriend") as? CDFriend
        return cdFriend != nil && (cdFriend!.email)! == ""
    }
}
