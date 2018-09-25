//
//  CDEvent+CoreDataProperties.swift
//  
//
//  Created by Leonardo Cid on 7/31/18.
//
//

import Foundation
import CoreData


extension CDEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEvent> {
        return NSFetchRequest<CDEvent>(entityName: "CDEvent")
    }

    @NSManaged public var idEvent: Int32
    @NSManaged public var name: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var image: String?
    @NSManaged public var eventDate: String?
    @NSManaged public var eventHour: String?
    @NSManaged public var isSocial: Bool
    @NSManaged public var likes: Int32
    @NSManaged public var liked: Bool
    

}
