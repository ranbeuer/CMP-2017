//
//  SponsorsViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/31/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit

class SponsorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView?
    // MARK: - Vars -
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = self.view.viewWithTag(3)
        bgView?.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if section == 1 {
            return 7
        }
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sponsorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
        let sponsorImg = String(format: "sponsor\(indexPath.section)\(indexPath.row)")
        let image = UIImage(named: sponsorImg)
        sponsorCell.backgroundImageView?.image = image!
        return sponsorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfrows = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let size = CGSize(width: collectionView.frame.size.width/CGFloat((numberOfrows > 4 ? (indexPath.row < 4 ? 4 :numberOfrows - 4 ): numberOfrows)) - 5, height: collectionView.frame.size.height / (numberOfrows > 4 ? 6 : 3))
        return size
    }
    
    @IBAction func skippPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}


