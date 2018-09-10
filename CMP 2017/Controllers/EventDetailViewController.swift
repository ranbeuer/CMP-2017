//
//  FirstViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import AERecord
import Kingfisher

class EventDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var galleryCollectionView : UICollectionView?
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventExhibitorImageView: UIImageView!
    @IBOutlet weak var eventExhibitorName: UILabel!
    @IBOutlet weak var eventExhibitorJob: UILabel!
    @IBOutlet weak var exhibitorContainer: UIView!
    
    var event : CDEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eventImageView.image = UIImage(named: "logo_cmp_ss")
        eventNameLabel.text = event!.name
        eventDescriptionLabel.text = event!.eventDescription
        self.title = NSLocalizedString("EventDetail", comment: "").uppercased()
        var widthConstraint : NSLayoutConstraint?
        for (_, constraint) in containerView.constraints.enumerated() {
            if (constraint.firstAttribute == .width || constraint.secondAttribute == .width) {
                widthConstraint = constraint
                break
            }
        }
        widthConstraint?.constant = self.view.frame.size.width
        containerView.setNeedsLayout()
        
        let gradient = CAGradientLayer()
        var rect = self.view.bounds
        rect.origin.y += (rect.size.height - (rect.size.height / 3))
        rect.size.height = rect.size.height / 3
        gradient.frame = rect
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.5), UIColor.white.cgColor]
        gradient.locations = [0, 0.6, 1]
        self.view.layer.addSublayer(gradient)
        
        if let exhibitor = getExhibitor(eventId: String((event?.idEvent)!)) {
            eventExhibitorName.text = exhibitor.name! + " " + exhibitor.lastName!
            eventExhibitorJob.text = exhibitor.degree!
            var url: URL
            if exhibitor.url!.starts(with: "http") {
                url = URL(string: exhibitor.url!)!
            } else {
                url = URL(string: WSHelper.getBaseURL() + exhibitor.url!)!
            }
            eventExhibitorImageView?.kf.setImage(with: url)
        } else {
            exhibitorContainer.removeFromSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.black)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! SponsorCell
        cell.backgroundImageView?.contentMode = .scaleAspectFill
        cell.backgroundImageView?.image = UIImage(named: "conference_def")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        return CGSize(width: height * 1.6, height: height)
    }

    func getExhibitor(eventId: String) -> CDExhibitor?{
        var request = CDEvExRelation.createFetchRequest()
        var query = "idEvent = \"" + eventId + "\""
        request.predicate = NSPredicate(format: query)
        let relations = AERecord.execute(fetchRequest: request)
        if (relations.count == 0){
            return nil
        }
        let relation = relations[0] as! CDEvExRelation
        request = CDExhibitor.createFetchRequest()
        query = "idExhibitor = \"" + String(relation.idExhibitor) + "\""
        request.predicate = NSPredicate(format: query)
        let exhibitorsResult = AERecord.execute(fetchRequest: request)
        if (exhibitorsResult.count == 0){
            return nil
        }
        return exhibitorsResult[0] as? CDExhibitor
    }
}

