//
//  SessionHelper.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 18/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class SessionHelper : NSObject {
    static var instance : SessionHelper = SessionHelper()
    
    /// Session token used to get access to communicate with the server. (read only)
    private(set) var sessionToken : String? = nil
    /// Server application token.
//    private var appToken : String? = nil
    ///
    private var client : String? = nil
    
    /// Token expiry
//    private var expiry : String? = nil
    /// Uid, email address.
//    private var uid : String? = nil
    
    
    
    /// User's email address.
    private(set) var email : String? = nil
    /// Indicates if the user's has logged in.
    private(set) var isUserLogged = false
    
    /// Indicates if Photo Instructions screen should be shown.
    var eventsDownloaded : Bool = false {
        didSet {
            UserDefaults.standard.set(eventsDownloaded, forKey: "EventsDownloaded")
            UserDefaults.standard.synchronize()
        }
    }
    
    var notShowPhotoInstructions : Bool {
        didSet {
            UserDefaults.standard.set(notShowPhotoInstructions, forKey: "DontShowInstructions")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// User's info.
    private(set) var user : User?;
    
    override init() {
        if let info : [String : String ]  = UserDefaults.standard.dictionary(forKey: "sessionInfo") as? [String:String] {
            isUserLogged = true
            sessionToken = info["sessionToken"]
            client = info["client"]
            email = info["email"]
        }
        
        if let userInfo : [String:Any] = UserDefaults.standard.dictionary(forKey: "userInfo") {
            user = User(JSON: userInfo)!
        }
        
        let instructions = UserDefaults.standard.bool(forKey: "DontShowInstructions")
        notShowPhotoInstructions = instructions
        
        let eventsDown = UserDefaults.standard.bool(forKey: "EventsDownloaded")
        eventsDownloaded = eventsDown
    }
    
    /// Stores and persists the session's information
    ///
    /// - Parameter sessionInfo: Session information.
    public func saveSessionInfo(_ sessionInfo: NSDictionary) {
        isUserLogged = true
        self.sessionToken = sessionInfo.value(forKey: "token") as? String
        self.email = sessionInfo.value(forKey:"email") as? String
        
//        self.client = sessionInfo.value(forKey: "Client") as? String
        let sessionInfo = ["sessionToken":sessionToken!,"email":email!] as [String : String]
        UserDefaults.standard.set(sessionInfo, forKey: "sessionInfo")
        UserDefaults.standard.synchronize()
    }
    
    /// Stores and persists the user's information.
    ///
    /// - Parameter userInfo: User's information.
    public func saveUserInfo(_ userInfo: [String: Any]) {
        let newUser = User(JSON: userInfo)!
        user = newUser
        if (user?.firstName == nil) {
            user?.firstName = ""
        }
        if (user?.lastName == nil) {
            user?.lastName = ""
        }
        
        UserDefaults.standard.set(user?.toJSON(), forKey: "userInfo")
        UserDefaults.standard.synchronize()
    }
    
    /// Server's configuration headers for every web service call.
    ///
    /// - Returns: Dictionary that represents the configuration.
//    public func getHeaders() -> [String : String] {
//        if (!isUserLogged) {
//            return [:]
//        }
//        let headers = ["Client":self.client,"Uid":self.uid,"Access-Token" : self.sessionToken,"expiry":self.expiry, "Token-Type" : "Bearer"]
//        return headers as! [String : String]
//    }
    
    func clearSessionInfo() {
        self.email = nil
        self.client = nil
        self.sessionToken = nil
        self.email = nil
        self.isUserLogged = false
        UserDefaults.standard.removeObject(forKey: "sessionInfo")
        UserDefaults.standard.removeObject(forKey: "userInfo")
        UserDefaults.standard.removeObject(forKey: "DontShowInstructions")
        UserDefaults.standard.removeObject(forKey: "PushNotificationsConfig")
        UserDefaults.standard.synchronize()
        
        let instructions = UserDefaults.standard.bool(forKey: "DontShowInstructions")
        notShowPhotoInstructions = instructions
        
    }
    
    
}
