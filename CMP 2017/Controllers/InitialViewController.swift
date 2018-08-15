//
//  InitialViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/30/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import UINavigationBar_Transparent
import AERecord
import CoreData
import SVProgressHUD

class InitialViewController : UIViewController {
    var eventsRetrieved = false
    var exhibitorsRetrieved = false
    var programRetrieved = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMainMenu() {
        if eventsRetrieved && exhibitorsRetrieved && programRetrieved {
            SVProgressHUD.dismiss()
            let sideMenu = SideMenuController()
            let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainSideMenu") as! SideMenuViewController
            let eventsViewController  = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsDailyViewController
            eventsViewController.title = "EVENTS"
            let navController = UINavigationController(rootViewController: eventsViewController)
            navController.navigationBar.setBarColor(UIColor.clear)
            sideMenu.embed(centerViewController: navController, cacheIdentifier: "events")
            sideMenu.embed(sideViewController: sideMenuViewController)
            self.show(sideMenu, sender: nil)
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
