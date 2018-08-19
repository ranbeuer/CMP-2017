//
//  WSHelper.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class WSHelper {
    private let devURL = "http://52.173.95.250:3333"
    /// Prod Base url
    private let prodURL = "http://api.unitedsteelsupply.com"
    
    let kURLEvents = "/events"
    let kURLLogin = "/session/login"
    let kURLCreateUser = "/users/create"
    let kURLEventsRelExhibitor = "/events/relation/exhibitor"
    let kURLExhibitor = "/events/exhibitor"
    let kURLDailyEvents = "/events/daily"
    let kURLAvatar = "/images/avatar"
    let kURLUploadAvatar = "/upload/avatar"
    
    
    /// Indicates if the application is pointing to prod or dev env
    let devEnv = true
    /// Configurable base URL, it can be either prod or dev
    static var baseURL : String!
    /// If set to true it will let the application to show the requests and responses
    static let logEverything = false
    
    /// Singleton instance
    static let sharedInstance = WSHelper()
    
    public typealias ResultBlockForEvents = (_ response: DataResponse<EventsResponse>?, _ error: Error?)-> Void
    public typealias ResultBlockForExhibitor = (_ response: DataResponse<ExhibitorResponse>?, _ error: Error?)-> Void
    public typealias ResultBlockForDEvent = (_ response: DataResponse<DailyEventsResponse>?, _ error: Error?)-> Void
    
    init() {
        WSHelper.setBaseURL(devEnv ? devURL : prodURL)
    }
    
    static func setBaseURL(_ url: String) {
        baseURL = url
    }
    
    static func getBaseURL() -> String! {
        return baseURL!
    }
    
    
    func getEvents(result: @escaping ResultBlockForEvents) {
        let url = WSHelper.getBaseURL() + kURLEvents
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: {  (response: DataResponse<EventsResponse>) in
            switch response.result {
            case .success:
                if (WSHelper.logEverything) {
                    let data = response.data as Data?
                    let jsonString = String(data: data!, encoding: .utf8)
                    print(jsonString!)
                }
                result(response, nil)
                break;
            case .failure(let error):
                if (WSHelper.logEverything) {
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(String(describing: json))")
                    }
                }
                result(nil, error)
            }
        })
    }
    
    func getExhibitors(result: @escaping ResultBlockForExhibitor) {
        let url = WSHelper.getBaseURL() + kURLExhibitor
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: {  (response: DataResponse<ExhibitorResponse>) in
            switch response.result {
            case .success:
                if (WSHelper.logEverything) {
                    let data = response.data as Data?
                    let jsonString = String(data: data!, encoding: .utf8)
                    print(jsonString!)
                }
                result(response, nil)
                break;
            case .failure(let error):
                if (WSHelper.logEverything) {
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(String(describing: json))")
                    }
                }
                result(nil, error)
            }
        })
    }
    
    func getDaily(result: @escaping ResultBlockForDEvent) {
        let url = WSHelper.getBaseURL() + kURLDailyEvents
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: {  (response: DataResponse<DailyEventsResponse>) in
            switch response.result {
            case .success:
                if (WSHelper.logEverything) {
                    let data = response.data as Data?
                    let jsonString = String(data: data!, encoding: .utf8)
                    print(jsonString!)
                }
                result(response, nil)
                break;
            case .failure(let error):
                if (WSHelper.logEverything) {
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(String(describing: json))")
                    }
                }
                result(nil, error)
            }
        })
    }
}
