//
//  EventsViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/30/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import Kingfisher
import AERecord
import SVProgressHUD

class EventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView : UICollectionView?
    
    var eventsArrray: [CDEvent]?
    var query: String?
    var imagesArray: [String] = ["sample_conf1", "sample_conf2","sample"]
    var sponsors : SponsorsViewController?
    var filterString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROGRAM"
        self.loadEvents()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (sponsors == nil && eventsArrray?.count != 0) {
            sponsors = self.storyboard?.instantiateViewController(withIdentifier: "Sponsors") as? SponsorsViewController
            sponsors?.modalPresentationStyle = .overCurrentContext
            sponsors?.modalTransitionStyle = .crossDissolve
            self.present(sponsors!, animated: true, completion: nil)
        } else if (eventsArrray?.count == 0) {
            SVProgressHUD.showError(withStatus: "No hay eventos para éste día.")
        }
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
        let dailyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProgramCell", for: indexPath) as! EventProgramCell
        let event = eventsArrray![indexPath.row]
        let url = WSHelper.sharedInstance.baseURL +  event.image!
        let placeholderIndex = indexPath.row % imagesArray.count
        dailyCell.backgroundImageView?.kf.setImage(with: URL(string: url), placeholder: UIImage(named: imagesArray[placeholderIndex]), options: nil, progressBlock: nil, completionHandler: { (image : UIImage, error: NSError?, cacheType : CacheType, url: URL?) in
            
            } as? CompletionHandler)
        dailyCell.layer.cornerRadius = 10
        dailyCell.nameLabel?.text = event.name
        dailyCell.descriptionLabel?.text = event.eventDate
        dailyCell.dateLabel?.text = event.eventHour
        
        return dailyCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.size.width - 30
        let size = CGSize(width: side, height: side)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = eventsArrray![indexPath.row]
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "EventDetail") as! EventDetailViewController
        detail.event = event
        self.show(detail, sender: nil)
    }
    
    func loadEvents() {
        let request = CDEvent.createFetchRequest()
        let query = "eventDate = \"" + filterString! + "\""
        request.predicate = NSPredicate(format: query)
        let results = AERecord.execute(fetchRequest: request)
        eventsArrray = results as? [CDEvent];
        self.collectionView?.reloadData()
//        WSHelper.sharedInstance.getEvents { (_ response : DataResponse<EventsResponse>?,_ error : Error?) in
//            if error == nil {
//                self.eventsArrray = response?.value?.result
//                self.collectionView?.reloadData()
//            }
//        }
        
    }
    
}
