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
            eventsViewController.title = NSLocalizedString("Events", comment: "").uppercased()
            let navController = UINavigationController(rootViewController: eventsViewController)
            navController.navigationBar.setBarColor(UIColor.clear)
            sideMenu.embed(centerViewController: navController, cacheIdentifier: "events")
            sideMenu.embed(sideViewController: sideMenuViewController)
            self.show(sideMenu, sender: nil)
        }
    }
    
    func saveEvents(_ events: [Event]) {
        for (_, event) in events.enumerated() {
            event.insertEvent()
        }
        AERecord.save()
    }
    
    func saveRelations(_ relations: [[String: Any]]) {
        for (_, obj) in relations.enumerated() {
            let rel = EventExhibitorRelation(JSON: obj)!
            rel.insertRelation()
        }
        AERecord.save()
       
    }
    
    func recordExists(id: Int, entity: String, field: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %d", id)
        
        let results = AERecord.execute(fetchRequest: fetchRequest)
        return results.count > 0
    }
    
    
    func saveDailyEvents(events: [DailyEvent]) {
        for (_, event) in events.enumerated() {
            event.insertEvent();
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
