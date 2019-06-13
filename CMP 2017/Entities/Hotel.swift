//
//  Hotel.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 6/12/19.
//  Copyright © 2019 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import GoogleMaps

class Hotel : NSObject, Mappable {
    var name: String?
    var coordinate: Coordinate?
    var snippet: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        coordinate <- map["coordinates"]
        snippet <- map["description"]
    }
}

class Coordinate : NSObject, Mappable {
    var lat: Double = 0
    var long: Double = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        long <- map["long"]
    }
    
    func cllcoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}
