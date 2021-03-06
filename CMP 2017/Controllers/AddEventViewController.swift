//
//  AddEventViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 18/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import UINavigationBar_Transparent
import AERecord
import CoreData
import SVProgressHUD

class AddEventViewController : UIViewController {
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var eventTextField : UITextField!
    @IBOutlet weak var searchButton : UIButton!
    
    var eventsRetrieved = false
    var exhibitorsRetrieved = false
    var programRetrieved = false
    var shownMenu = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let avatarframe = avatarImageView.frame
        avatarImageView.layer.cornerRadius = avatarframe.size.height / 2
        avatarImageView.clipsToBounds = true
        WSHelper.sharedInstance.getUserProfile(email: SessionHelper.instance.email!) { (response, error) in
            if error == nil {
                let responseObj = response as! [String : Any]
                SessionHelper.instance.saveUserInfo(responseObj["profile"] as! [String : Any])
                self.showProfileInfo()
                
//                let fcmSent = UserDefaults.standard.bool(forKey: "FCMSent")
//                if !fcmSent {
                    if let fcmToken = UserDefaults.standard.string(forKey: "FCMToken")  {
                        let user = SessionHelper.instance.user
                        WSHelper.sharedInstance.register(fcmToken: fcmToken, email: (user?.email)!) { (response, error) in
                            if (error == nil) {
                                UserDefaults.standard.set(true, forKey: "FCMSent")
                            } else {
                                print(error?.localizedDescription)
                            }
                        }
                    }
//                }
            }
        }
        WSHelper.sharedInstance.getFriends { (response, error) in
            if (error == nil) {
                let result = response?.value
                if (result?.code == 200) {
                    result?.friends?.forEach({ (friend) in
                        if (!friend.existsFriendAndNeedsUpdate()) {
                            WSHelper.sharedInstance.getUserProfile(email: friend.receiver!, result: { (response, error) in
                                if (error == nil) {
                                    let responseObj = response as! [String : Any]
                                    friend.updateData(info:responseObj["profile"] as! [String : Any])
                                    friend.insertFriend()
                                    AERecord.save()
                                }
                            })
                        }
                        
                    })
                    //                    AERecord.saveAndWait()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
//        if (eventTextField.text == "cmp2018") {
            retrieveInfo()
//        } else {
//            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorInvalidEvent", comment: ""))
//        }
    }
    
    func retrieveInfo() {
        SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressWait", comment: ""))
        WSHelper.sharedInstance.getEvents(isSocial: false) { (_ response: DataResponse<EventsResponse>?,_ error: Error?) in
            if error == nil {
                self.saveEvents((response?.value?.result)!)
                WSHelper.sharedInstance.getExhibitorEventRelations { (response, error) in
                    if (error == nil) {
                        let jsonArray = response as! [[String:Any]]
                        self.saveRelations(jsonArray)
                    }
                    self.programRetrieved = true
                    self.showMainMenu()
                }
            }
        }
        WSHelper.sharedInstance.getExhibitors { (_ response: DataResponse<ExhibitorResponse>?,_ error: Error?) in
            if error == nil {
                self.saveExhibitors((response?.value?.result)!)
            }
            self.exhibitorsRetrieved = true
            self.showMainMenu()
        }
        
        WSHelper.sharedInstance.getDaily(isSocial: false) { (_ response : DataResponse<DailyEventsResponse>?,_ error : Error?) in
            if error == nil {
                self.saveDailyEvents(events: (response?.value?.result)!)
            }
            self.eventsRetrieved = true
            self.showMainMenu()
        }
        
    }
    
    func showProfileInfo() {
        let user = SessionHelper.instance.user
        nameLabel.text = NSLocalizedString("WelcomeHi", comment: "").replacingOccurrences(of: "<user>", with: (user?.firstName)!)
        var url: URL
        if (user?.avatarImg)!.starts(with: "http") {
            url = URL(string: (user?.avatarImg)!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + (user?.avatarImg)!)!
        }
        let image = #imageLiteral(resourceName: "ic_avatar_placeholder")
        avatarImageView.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        avatarImageView.kf.setImage(with: url)
    }
    
    func showMainMenu() {
        if eventsRetrieved && exhibitorsRetrieved && programRetrieved {
            if (shownMenu) {
                return
            }
            SessionHelper.instance.eventsDownloaded = true
            shownMenu = true
            SVProgressHUD.dismiss()
            let sideMenu = SideMenuController()
            let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainSideMenu") as! SideMenuViewController
            let eventsViewController  = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsDailyViewController
            eventsViewController.title = NSLocalizedString("Events", comment: "").uppercased()
            let navController = UINavigationController(rootViewController: eventsViewController)
            navController.navigationBar.setBarColor(UIColor.clear)
            sideMenu.embed(centerViewController: navController, cacheIdentifier: "events")
            sideMenu.embed(sideViewController: sideMenuViewController)
            sideMenu.modalTransitionStyle = .crossDissolve
            self.present(sideMenu, animated: true, completion: nil)
        }
    }
    
    func saveEvents(_ events: [Event]) {
        for (_, event) in events.enumerated() {
            event.insertEvent()
        }
        AERecord.saveAndWait()
    }
    
    func recordExists(id: Int, entity: String, field: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %d", id)
        
        let results = AERecord.execute(fetchRequest: fetchRequest)
        return results.count > 0
    }
    
    
    func saveDailyEvents(events: [DailyEvent]) {
        for (_, event) in events.enumerated() {
            event.insertEvent()
        }
        AERecord.saveAndWait()
    }
    
    func saveRelations(_ relations: [[String: Any]]) {
        for (_, obj) in relations.enumerated() {
            let rel = EventExhibitorRelation(JSON: obj)!
            rel.insertRelation()
        }
        AERecord.save()
        
    }
    
    func saveExhibitors(_ exhibitors: [Exhibitor]) {
        for (_, exhibitor) in exhibitors.enumerated() {
            exhibitor.insertExhibitor()
        }
        AERecord.save()
    }
}
