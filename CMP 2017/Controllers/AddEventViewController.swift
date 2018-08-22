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
        WSHelper.sharedInstance.getUserProfile { (_ response : Any?, _ error: Error?) in
            if error == nil {
                SessionHelper.instance.saveUserInfo(response as! [String : Any])
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
        retrieveInfo()
    }
    
    func retrieveInfo() {
        SVProgressHUD.show(withStatus: "Por favor espere...")
        WSHelper.sharedInstance.getEvents { (_ response: DataResponse<EventsResponse>?,_ error: Error?) in
            if error == nil {
                self.saveEvents((response?.value?.result)!)
            }
            self.programRetrieved = true
            self.showMainMenu()
        }
        WSHelper.sharedInstance.getExhibitors { (_ response: DataResponse<ExhibitorResponse>?,_ error: Error?) in
            if error == nil {
                self.saveExhibitors((response?.value?.result)!)
            }
            self.exhibitorsRetrieved = true
            self.showMainMenu()
        }
        
        WSHelper.sharedInstance.getDaily { (_ response : DataResponse<DailyEventsResponse>?,_ error : Error?) in
            if error == nil {
                self.saveDailyEvents(events: (response?.value?.result)!)
            }
            self.eventsRetrieved = true
            self.showMainMenu()
        }
    }
    
    func showMainMenu() {
        if eventsRetrieved && exhibitorsRetrieved && programRetrieved {
            if (shownMenu) {
                return
            }
            shownMenu = true
            SVProgressHUD.dismiss()
            let sideMenu = SideMenuController()
            let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainSideMenu") as! SideMenuViewController
            let eventsViewController  = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsDailyViewController
            eventsViewController.title = "EVENTS"
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
            insertEvent(event: event)
        }
        AERecord.saveAndWait()
    }
    
    func recordExists(id: Int, entity: String, field: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %d", id)
        
        let results = AERecord.execute(fetchRequest: fetchRequest)
        return results.count > 0
    }
    
    func insertEvent(event: Event) {
        if !recordExists(id: event.idEvent!, entity: "CDEvent", field: "idEvent") {
            CDEvent.create(with: ["idEvent":event.idEvent!,"eventDate":event.eventDate!,"eventDescription":event.eventDescription!,"eventHour":event.eventHour!,"image":event.image!,"name":event.name!])
            AERecord.saveAndWait()
        }
    }
    
    func saveDailyEvents(events: [DailyEvent]) {
        for (i, event) in events.enumerated() {
            insertDailyEvent(event: event)
        }
        AERecord.saveAndWait()
    }
    
    func insertDailyEvent(event: DailyEvent) {
        if !recordExists(id: event.idDailyEvent!, entity: "CDDailyEvent", field: "id") {
            CDDailyEvent.create(with: ["id":event.idDailyEvent!,"dailyEventDate":event.dailyEventDate!,"dailyEventDescription":event.dailyEventDescription!,"dailyEventPicture":event.dailyEventPicture!,"image":event.image!,"dailyEventName":event.dailyEventName!])
        }
    }
    
    func saveExhibitors(_ exhibitors: [Exhibitor]) {
        for (i, exhibitor) in exhibitors.enumerated() {
            insertExhibitor(exhibitor: exhibitor)
        }
        AERecord.saveAndWait()
    }
    func insertExhibitor(exhibitor: Exhibitor ) {
        if !recordExists(id: exhibitor.idExhibitor!, entity: "CDExhibitor", field: "idExhibitor") {
            CDExhibitor.create(with: ["idExhibitor":exhibitor.idExhibitor!,"degree":exhibitor.degree!,"email":exhibitor.email!,"history":exhibitor.history!,"job":exhibitor.job!,"lastName":exhibitor.lastName ?? "", "name":exhibitor.name!, "phoneNumber":exhibitor.phonenumber!, "url":exhibitor.picture!, "type":exhibitor.type!])
        }
    }
}
