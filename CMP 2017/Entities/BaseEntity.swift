//
//  BaseEntity.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 22/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord
import CoreData

class BaseEntity : NSObject, Mappable {
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    required init?(map: Map){
        
    }
    
    func recordExists(id: Int, entity: String, field: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %d", id)
        
        let results = AERecord.execute(fetchRequest: fetchRequest)
        return results.count > 0
    }
    
    func getCDEquivalent(id: Int, entity: String, field: String) -> NSManagedObject?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %d", id)
        
        let results = AERecord.execute(fetchRequest: fetchRequest)
        if (results.count != 0) {
            return results[0]
        }
        return nil
    }
    
}
