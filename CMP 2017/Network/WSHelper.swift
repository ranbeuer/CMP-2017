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
    
    
    let kURLLogin =                 "/session/login"
    let kURLCreateUser =            "/users/create"
    let kURLUserProfile =           "/profile/minimum"
    let kURLGetFriends =            "/profile/friends"
    let kURLAddFriends =            "/profile/addfriend"
    let kURLEvents =                "/events"
    let kURLExhibitor =             "/events/exhibitor"
    let kURLDailyEvents =           "/events/daily"
    let kURLEventsRelExhibitor =    "/events/relation/exhibitor"
    let kURLGetAvatar =             "/images/avatar"
    let kURLUploadAvatar =          "/upload/avatar"
    
    
    /// Indicates if the application is pointing to prod or dev env
    let devEnv = true
    /// Configurable base URL, it can be either prod or dev
    static var baseURL : String!
    /// If set to true it will let the application to show the requests and responses
    static let logEverything = false
    
    /// Singleton instance
    static let sharedInstance = WSHelper()
    
     typealias ResultBlockForEvents = (_ response: DataResponse<EventsResponse>?, _ error: Error?)-> Void
     typealias ResultBlockForExhibitor = (_ response: DataResponse<ExhibitorResponse>?, _ error: Error?)-> Void
     typealias ResultBlockForDEvent = (_ response: DataResponse<DailyEventsResponse>?, _ error: Error?)-> Void
    typealias ResultBlockForFriends = (_ response: DataResponse<FriendsResponse>?, _ error: Error?)-> Void
     typealias ResultBlock = (_ response: Any?, _ error: Error?)-> Void
    
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
    
    func getUserProfile(result: @escaping ResultBlock) {
        let url = WSHelper.getBaseURL() + kURLUserProfile
        let email = SessionHelper.instance.email
        let token = SessionHelper.instance.sessionToken
        genericPost(url: url, parameters: ["email":email,"token":token], callback: result)
        
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
    
    func genericPost(url: URLConvertible, parameters:[String:Any]?, callback result: @escaping ResultBlock ) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default
            , headers: nil).responseJSON { response in
                switch(response.result) {
                case .success:
                    let json = response.result.value as! Dictionary <String, Any>
                    let code = json["code"] as! Int
                    if (code == 200) {
                        let finalresponse = json["response"]
                        result(finalresponse, nil)
                    } else {
                        let errorMessage = json["message"];
                        let finalError = NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage as Any])
                        result(nil, finalError)
                    }
                    break;
                case .failure(let error) :
                    result(nil, error)
                    break;
                }
        }
    }
    
    func login(email: String, password: String, withResult result: @escaping ResultBlock) {
        let url = WSHelper.baseURL + kURLLogin
        let parameters = ["email": email,"password":password]
        genericPost(url: url, parameters: parameters, callback: result)
    }
    
    func createUser(email: String, password: String, name: String, lastName: String,  withResult result: @escaping ResultBlock) {
        let url = WSHelper.baseURL + kURLCreateUser
        let parameters = ["email": email,"password":password, "name": name, "lastname": lastName ]
        genericPost(url: url, parameters: parameters, callback: result)
    }
    
    func genericGet(url: URLConvertible, parameters:[String:Any]?, callback result: @escaping ResultBlock ) {
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default
            , headers: nil).responseJSON { response in
                switch(response.result) {
                case .success:
                    let json = response.result.value as! Dictionary <String, Any>
                    let code = json["code"] as! Int
                    if (code == 200) {
                        let finalresponse = json["response"]
                        result(finalresponse, nil)
                    } else {
                        let errorMessage = json["message"];
                        let finalError = NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage as Any])
                        result(nil, finalError)
                    }
                    break;
                case .failure(let error) :
                    result(nil, error)
                    break;
                }
        }
    }
    
    
    
}
