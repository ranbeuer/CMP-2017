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
import AFNetworking

class WSHelper {
    static private let devURL = "http://52.173.95.250:3333"
    /// Prod Base url
    static private let prodURL = "http://142.93.115.237:3333"
    
    
    let kURLLogin =                 "/session/login" //ya
    let kURLCreateUser =            "/users/create"  //ya
    let kURLUserProfile =           "/profile/minimum"  //ya
    let kURLGetFriends =            "/profile/friends"  //ya
    let kURLAddFriends =            "/profile/addfriend"
    let kURLEvents =                "/events" //ya
    let kURLExhibitor =             "/events/exhibitor" //ya
    let kURLDailyEvents =           "/events/daily" //ya
    let kURLEventsRelExhibitor =    "/events/relation/exhibitor"
    let kURLGetAvatar =             "/images/avatar"
    let kURLUploadAvatar =          "/upload/avatar"
    
    let manager = AFHTTPSessionManager(baseURL: URL(string: WSHelper.baseURL))
    
    /// Indicates if the application is pointing to prod or dev env
    static let devEnv = false
    /// Configurable base URL, it can be either prod or dev
    private static var baseURL = WSHelper.devEnv ? WSHelper.devURL : WSHelper.prodURL
    /// If set to true it will let the application to show the requests and responses
    static let logEverything = false
    
    static let USE_AFNETWORKING = true
    
    /// Singleton instance
    static let sharedInstance = WSHelper()
    
    typealias ResultBlockForEvents = (_ response: DataResponse<EventsResponse>?, _ error: Error?)-> Void
    typealias ResultBlockForExhibitor = (_ response: DataResponse<ExhibitorResponse>?, _ error: Error?)-> Void
    typealias ResultBlockForDEvent = (_ response: DataResponse<DailyEventsResponse>?, _ error: Error?)-> Void
    typealias ResultBlockForFriends = (_ response: DataResponse<FriendsResponse>?, _ error: Error?)-> Void
    typealias ResultBlockForMessages = (_ response: DataResponse<MessagesResponse>?, _ error: Error?)-> Void

     typealias ResultBlock = (_ response: Any?, _ error: Error?)-> Void
    
    init() {
        
    }
    
    static func setBaseURL(_ url: String) {
        baseURL = url
    }
    
    static func getBaseURL() -> String! {
        return WSHelper.baseURL
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
    
    func getFriends(result: @escaping ResultBlockForFriends) {
        let url = WSHelper.getBaseURL() + kURLGetFriends
        let email = SessionHelper.instance.email
        let token = SessionHelper.instance.sessionToken
        Alamofire.request(url, method: .post, parameters:  ["email":email!,"token":token!], encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: {  (response: DataResponse<FriendsResponse>) in
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
    
    func getUserProfile(email: String, result: @escaping ResultBlock) {
        let url = WSHelper.getBaseURL() + kURLUserProfile
        let token = SessionHelper.instance.sessionToken
        genericPost(url: url, parameters: ["email":email,"token":token!], callback: result)
        
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
    
    func genericPost(url: String, parameters:[String:Any]?, callback result: @escaping ResultBlock ) {
        if (WSHelper.USE_AFNETWORKING) {
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.post(url, parameters: parameters, progress: nil, success: { (task, response) in
                let json = response as! Dictionary <String, Any>
                let code = json["code"] as! Int
                if (code == 200) {
                    let finalresponse = json["response"]
                    result(finalresponse, nil)
                } else {
                    let errorMessage = json["message"];
                    let finalError = NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage as Any])
                    result(nil, finalError)
                }
            }) { (task, error) in
                result(nil, error)
            }
        } else {
            let urlconv = WSHelper.getBaseURL() + url
            Alamofire.request(urlconv as URLConvertible, method: .post, parameters: parameters, encoding: URLEncoding.default
                , headers: nil).responseJSON { response in
                    switch(response.result) {
                    case .success:
                        
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("*******Response: \n\(json!)")
                        }
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
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("*******Failure Response: \n\(json!)")
                        }
                        
                        result(nil, error)
                        break;
                    }
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
    
    func uplooadAvatar(_ data: Data, email: String, result: @escaping ResultBlock) {
        if WSHelper.USE_AFNETWORKING {
            
            
            manager.requestSerializer.setValue(email, forHTTPHeaderField: "email")
            manager.requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
            /*let request = manager.requestSerializer.multipartFormRequest(withMethod: "POST", urlString: kURLUploadAvatar, parameters: nil, constructingBodyWith: { (multipartFormData) in
                multipartFormData.appendPart(withFileData: data, name: "file", fileName: "file.png", mimeType: "image/png")
            }, error: nil)
            manager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, responseObject, error) in
                if (error == nil) {
                    result(responseObject, nil)
                } else {
                    result(nil, error)
                }
            }*/
            manager.post(kURLUploadAvatar, parameters: nil, constructingBodyWith: { (multipartFormData) in
                multipartFormData.appendPart(withFileData: data, name: "file", fileName: "file.png", mimeType: "image/png")
            }, progress: nil, success: { (task, response) in
                let json = response as! Dictionary <String, Any>
                let code = json["code"] as! Int
                if (code == 200) {
                    let finalresponse = json["response"]
                    result(finalresponse, nil)
                } else {
                    let errorMessage = json["message"];
                    let finalError = NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage as Any])
                    result(nil, finalError)
                }
            }) { (task, error) in
                result(nil, error)
            }
            
        } else {
            let url = WSHelper.baseURL + kURLUploadAvatar
            let headers = ["email": email, "Accept":"multipart/form-data"]
            Alamofire.upload(multipartFormData: { (multipartformdata) in
                multipartformdata.append(data, withName: "File")
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (multipartResponse) in
                switch multipartResponse {
                case .failure(let error):
                    result(nil, error)
                    break
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        //                        self.showSuccesAlert()
                        if let JSON = response.result.value {
                            result(JSON, nil)
                        }
                    }
                    break
                }
            }
        }
    }
    
    
    
    func urlForAvatarWith(email: String) -> String {
        return WSHelper.getBaseURL() + kURLGetAvatar + "/" + email + ".png"
    }
    
}
