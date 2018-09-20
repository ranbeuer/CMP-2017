//
//  Route.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 17/09/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper
import AERecord

class RouteDetail : BaseEntity  {
    var idRouteDetail : NSInteger?
    var day : String?
    var month : String?
    var year : String?
    var routeName : String?
    var routeDescription : String?
    var hourLabel : String?
    var hourNumber : String?
    var date: Date?
    
    static let formatter = DateFormatter(withFormat: "dd-MM-yyyy", locale: Locale.current.languageCode!)
    static let calendar = Calendar(identifier: .gregorian)
    
    override func mapping(map: Map) {
        idRouteDetail <- map["idRouteDetail"]
        day <- map["day"]
        month <- map["month"]
        year <- map["year"]
        routeName <- map["routeName"]
        routeDescription <- map["description"]
        hourLabel <- map["hourLabel"]
        hourNumber <- map["hourNumber"]
        let dateStr = dateString()
        date = Route.formatter.date(from: dateStr)
    }
    
    func dateString() -> String {
        let dateStr = day! + "-" + month! + "-" + year!
        return dateStr
    }
    
    func dateKey() -> String {
        let day = Route.calendar.component(.weekday, from: date!)
        let weekday = Route.formatter.weekdaySymbols[day-1]
        let key = weekday + " " + String(Route.calendar.component(.day, from: date!))
        return key;
    }
    
    
}


