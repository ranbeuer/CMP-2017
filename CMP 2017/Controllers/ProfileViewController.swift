//
//  ProfileViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/15/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import QRCode
import Alamofire
import AERecord
import Kingfisher

class ProfileViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    var friendsArray : [CDFriend]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SessionHelper.instance.user == nil {
            SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressWait", comment: ""))
        } else {
            showProfileInfo()
            showFriends()
        }
        WSHelper.sharedInstance.getUserProfile(email: SessionHelper.instance.email!) { (_ response: Any?, _ error: Error?) in
            SVProgressHUD.dismiss()
            if (error == nil) {
                let responseObj = response as! [String : Any]
                SessionHelper.instance.saveUserInfo(responseObj["profile"] as! [String : Any])
                self.showProfileInfo()
            }
        }
        
        WSHelper.sharedInstance.getFriends { (_ response: DataResponse<FriendsResponse>?, _ error: Error?) in
            if (error == nil) {
                let result = response?.value
                if (result?.code == 200) {
                    result?.friends?.forEach({ (friend) in
                        if (!friend.exists() || friend.existsFriendAndNeedsUpdate()) {
                            WSHelper.sharedInstance.getUserProfile(email: friend.receiver!, result: { (response, error) in
                                if (error == nil) {
                                    let responseObj = response as! [String : Any]
                                    friend.updateData(info:responseObj["profile"] as! [String : Any])
                                    friend.insertFriend()
                                    AERecord.save()
                                }
                            })
                        }
                    })
                    self.showFriends()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        self.sideMenuController?.toggle()
    }
    
    func showProfileInfo() {
        let user = SessionHelper.instance.user
        nameLabel.text = (user?.firstName)! + " " + (user?.lastName)!
        userIdLabel.text = (user?.email)!
        let qr = QRCode((user?.email)!)
        var url: URL
        if (user?.avatarImg)!.starts(with: "http") {
            url = URL(string: (user?.avatarImg)!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + (user?.avatarImg)!)!
        }
        avatarImageView.kf.setImage(with: url)
        qrImageView.image = qr?.image
    }
    
    func showFriends() {
        
        let request = CDFriend.createFetchRequest()
        let results = AERecord.execute(fetchRequest: request)
        friendsArray = results as? [CDFriend];
        self.contactsCollectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (friendsArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PContactCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        let friend = friendsArray[indexPath.row]
        let url = URL(string: WSHelper.sharedInstance.urlForAvatarWith(email: friend.receiver!))
        imageView.kf.setImage(with: url)
        return cell
    }
}
