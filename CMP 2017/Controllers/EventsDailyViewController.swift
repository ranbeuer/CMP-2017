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

class EventsDailyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView : UICollectionView?
    
    var eventsArrray: [CDDailyEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let flowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.minimumLineSpacing = 0
        self.loadDailyEvents()
        // Do any additional setup after loading the view, typically from a nib.
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
        dailyCell.backgroundImageView?.kf.setImage(with: URL(string: event.image!))
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
        self.collectionView?.reloadData()
//        WSHelper.sharedInstance.getDaily { (_ response : DataResponse<DailyEventsResponse>?,_ error : Error?) in
//            if error == nil {
//                self.eventsArrray = response?.value?.result
//                self.collectionView?.reloadData()
//            }
//        }
    }
}
