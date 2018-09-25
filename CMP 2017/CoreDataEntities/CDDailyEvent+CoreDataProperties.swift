//
//  CDDailyEvent+CoreDataProperties.swift
//  
//
//  Created by Leonardo Cid on 7/31/18.
//
//

import Foundation
import CoreData


extension CDDailyEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDailyEvent> {
        return NSFetchRequest<CDDailyEvent>(entityName: "CDDailyEvent")
    }

    @NSManaged public var id: Int32
    @NSManaged public var dailyEventName: String?
    @NSManaged public var dailyEventDescription: String?
    @NSManaged public var image: String?
    @NSManaged public var dailyEventDate: String?
    @NSManaged public var dailyEventStartsAt: String?
    @NSManaged public var dailyEventPicture: String?
    @NSManaged public var isSocial: Bool
    @NSManaged public var likes: Int32
    @NSManaged public var liked: Bool

}
