//
//  CDExhibitor+CoreDataProperties.swift
//  
//
//  Created by Leonardo Cid on 18/08/18.
//
//

import Foundation
import CoreData


extension CDExhibitor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExhibitor> {
        return NSFetchRequest<CDExhibitor>(entityName: "CDExhibitor")
    }

    @NSManaged public var degree: String?
    @NSManaged public var email: String?
    @NSManaged public var history: String?
    @NSManaged public var idExhibitor: Int32
    @NSManaged public var job: String?
    @NSManaged public var lastName: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var type: Int32
    @NSManaged public var url: String?

}
