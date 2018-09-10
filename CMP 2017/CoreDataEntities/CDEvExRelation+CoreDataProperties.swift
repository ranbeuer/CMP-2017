//
//  CDEvExRelation+CoreDataProperties.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 10/09/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//
//

import Foundation
import CoreData


extension CDEvExRelation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEvExRelation> {
        return NSFetchRequest<CDEvExRelation>(entityName: "CDEvExRelation")
    }

    @NSManaged public var idEventExhibitor: Int32
    @NSManaged public var idEvent: Int32
    @NSManaged public var idExhibitor: Int32

}
