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
    var social : Bool = false
    var indexesForLoad = IndexSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Program", comment: "").uppercased()
        self.loadEvents()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.white)
        indexesForLoad.removeAll()
        self.collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (sponsors == nil && eventsArrray?.count != 0) {
            sponsors = self.storyboard?.instantiateViewController(withIdentifier: "Sponsors") as? SponsorsViewController
            sponsors?.modalPresentationStyle = .overCurrentContext
            sponsors?.modalTransitionStyle = .crossDissolve
            self.present(sponsors!, animated: true, completion: nil)
        } else if (eventsArrray?.count == 0) {
            SVProgressHUD.showError(withStatus:NSLocalizedString("DialogMessageNoEventsForDay", comment: ""))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        var url : URL
        if event.image!.starts(with: "http") {
            url = URL(string: event.image!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + event.image!)!
        }
        let placeholderIndex = indexPath.row % imagesArray.count
        dailyCell.backgroundImageView?.kf.setImage(with: url, placeholder: UIImage(named: imagesArray[placeholderIndex]), options: nil, progressBlock: nil, completionHandler: { (image : UIImage, error: NSError?, cacheType : CacheType, url: URL?) in
            
            } as? CompletionHandler)
        dailyCell.layer.cornerRadius = 10
        dailyCell.nameLabel?.text = event.name
        dailyCell.descriptionLabel?.text = event.eventDate
        dailyCell.dateLabel?.text = event.eventHour
        dailyCell.likesLabel?.text = String(event.likes)
        
        let imageName = event.liked ? "ic_fav_ribbon" : "ic_no_fav_ribbon"
        let image = UIImage(named: imageName)
        dailyCell.bookmarkImageView?.image = image
        
        if !indexesForLoad.contains(indexPath.row) {
            WSHelper.sharedInstance.getEventsLike(social: self.social, idEvent: Int(event.idEvent)) { (result, error) in
                if (error == nil) {
                    self.indexesForLoad.insert(indexPath.row)
                    let response = result as! [[String:NSInteger]]
                    let likesDict = response[0]
                    let likes = likesDict["count"]
                    event.likes = Int32(likes!)
                    AERecord.save()
                    collectionView.reloadData()
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
        
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
        var query = "eventDate = \"" + filterString! + "\""
         query += " AND isSocial = " + String(self.social)
        request.predicate = NSPredicate(format: query)
        request.sortDescriptors = [NSSortDescriptor(key: "eventHour", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
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
