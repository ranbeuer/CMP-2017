//
//  CDFriend+CoreDataProperties.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 24/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//
//

import Foundation
import CoreData


extension CDFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFriend> {
        return NSFetchRequest<CDFriend>(entityName: "CDFriend")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var idFriend: Int32
    @NSManaged public var receiver: String?
    @NSManaged public var sender: String?
    @NSManaged public var email: String?
    @NSManaged public var avatarImage: String?
    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var idAvatar: Int32

}
