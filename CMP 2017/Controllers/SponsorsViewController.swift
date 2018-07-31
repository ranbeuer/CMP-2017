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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sponsorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
        let sponsorImg = String(format: "sponsor\(indexPath.row + 1)")
        let image = UIImage(named: sponsorImg)
        sponsorCell.backgroundImageView?.image = image!
        return sponsorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height / 3)
        return size
    }
    
    @IBAction func skippPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}


