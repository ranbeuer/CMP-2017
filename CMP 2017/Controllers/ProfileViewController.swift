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
class ProfileViewController : UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SessionHelper.instance.user == nil {
            SVProgressHUD.show(withStatus: "Please wait...")
        } else {
            showProfileInfo()
        }
        WSHelper.sharedInstance.getUserProfile { (_ response: Any?, _ error: Error?) in
            SVProgressHUD.dismiss()
            if (error == nil) {
                SessionHelper.instance.saveUserInfo(response as! [String : Any])
                self.showProfileInfo()
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
        qrImageView.image = qr?.image
    }
}
