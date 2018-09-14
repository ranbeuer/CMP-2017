//
//  SecondViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Kingfisher
import AERecord
import CoreData
import SVProgressHUD

class EventsDailyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView : UICollectionView?
    @IBOutlet var reloadButton : UIButton?
    var loadingObjects : Bool = false;
    
    var eventsArrray: [CDDailyEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let flowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.minimumLineSpacing = 0
        self.loadDailyEvents()
        reloadButton?.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout = CenteredFlowLayout(with: CGSize(width: UIScreen.main.bounds.size.width - 30, height: (self.collectionView?.frame.size.height)! - 30))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArrray != nil ? (eventsArrray?.count)! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dailyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyEventCell
        let event = eventsArrray![indexPath.row]
        var url: URL
        if event.image!.starts(with: "http") {
            url = URL(string: event.image!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + event.image!)!
        }
        dailyCell.backgroundImageView?.kf.setImage(with: url)
        dailyCell.layer.cornerRadius = 10
        dailyCell.nameLabel?.text = event.dailyEventName
        dailyCell.descriptionLabel?.text = event.dailyEventDescription
        dailyCell.quotationlabel?.text = event.dailyEventDate
        
        return dailyCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width - 30, height: collectionView.frame.size.height - 30)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Program") as! EventsViewController
        let event = eventsArrray![indexPath.row]
        newViewController.filterString = event.dailyEventDate
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func loadDailyEvents() {
        let sortDescriptor = NSSortDescriptor(key: "dailyEventDate", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let request = CDDailyEvent.createFetchRequest(predicate: nil, sortDescriptors: [sortDescriptor])
        let results = AERecord.execute(fetchRequest: request)
        eventsArrray = results as? [CDDailyEvent];
        self.collectionView?.performBatchUpdates({
            self.collectionView?.reloadData()
        }, completion: { (finished: Bool) in
            
        })
        
//        WSHelper.sharedInstance.getDaily { (_ response : DataResponse<DailyEventsResponse>?,_ error : Error?) in
//            if error == nil {
        
//                self.eventsArrray = response?.value?.result
//                self.collectionView?.reloadData()
//            }
//        }
    }
    
    @IBAction func reloadButtonPressed(sender: UIButton) {
        if !loadingObjects {
            loadingObjects = true;
            SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressLoading", comment: ""))
            reloadEvents()
        }
    }
    
    func reloadEvents() {
        WSHelper.sharedInstance.getEvents { (_ response: DataResponse<EventsResponse>?,_ error: Error?) in
            if error == nil {
                self.saveEvents((response?.value?.result)!)
            }
        }
        
        WSHelper.sharedInstance.getDaily { (_ response : DataResponse<DailyEventsResponse>?,_ error : Error?) in
            if error == nil {
                self.saveDailyEvents(events: (response?.value?.result)!)
                self.loadDailyEvents()
                SVProgressHUD.dismiss()
                self.loadingObjects = false;

            }
        }
        WSHelper.sharedInstance.getExhibitorEventRelations { (response, error) in
            if (error == nil) {
                let jsonArray = response as! [[String:Any]]
                self.saveRelations(jsonArray)
            }
        }
        
        WSHelper.sharedInstance.getExhibitors { (_ response: DataResponse<ExhibitorResponse>?,_ error: Error?) in
            if error == nil {
                self.saveExhibitors((response?.value?.result)!)
            }
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
    
    func saveExhibitors(_ exhibitors: [Exhibitor]) {
        for (_, exhibitor) in exhibitors.enumerated() {
            exhibitor.insertExhibitor()
        }
        AERecord.save()
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
    
    func saveRelations(_ relations: [[String: Any]]) {
        for (_, obj) in relations.enumerated() {
            let rel = EventExhibitorRelation(JSON: obj)!
            rel.insertRelation()
        }
        AERecord.save()
        
    }
}
