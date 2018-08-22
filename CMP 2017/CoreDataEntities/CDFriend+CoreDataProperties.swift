//
//  CDFriend+CoreDataProperties.swift
//  
//
//  Created by Leonardo Cid on 22/08/18.
//
//

import Foundation
import CoreData


extension CDFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFriend> {
        return NSFetchRequest<CDFriend>(entityName: "CDFriend")
    }

    @NSManaged public var idFriend: Int32
    @NSManaged public var sender: String?
    @NSManaged public var receiver: String?
    @NSManaged public var createdAt: String?

}
