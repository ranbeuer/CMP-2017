//
//  ContactsViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/17/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AERecord
import Alamofire
import AVFoundation
import QRCodeReader
import SVProgressHUD

class ContactsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, QRCodeReaderViewControllerDelegate {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var friendsArray : [CDFriend]!
    @IBOutlet weak var contactsTableView: UITableView!
    
    static let botChat: Chat = {
        let chat = Chat()
        chat.type = "bot"
        chat.targetId = "89757"
        chat.chatId = chat.type + "_" + chat.targetId
        chat.title = "Gothons From Planet Percal #25"
        chat.detail = "bot"
        return chat
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showFriends()
        fetchFriends()
        
        let button: UIButton = UIButton (type: UIButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "ic_add_contact"), for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(addContactPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addContactPressed(btn : UIButton) {
        
        self.readerVC.delegate = self
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
        }
        self.present(self.readerVC, animated: true, completion: nil)
    }
    
    
    func showFriends() {
        
        let request = CDFriend.createFetchRequest()
        let results = AERecord.execute(fetchRequest: request)
        friendsArray = results as? [CDFriend];
        self.contactsTableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchFriends() {
        WSHelper.sharedInstance.getFriends { (_ response: DataResponse<FriendsResponse>?, _ error: Error?) in
            if (error == nil) {
                let result = response?.value
                if (result?.code == 200) {
                    result?.friends?.forEach({ (friend) in
                        friend.insertFriend()
                    })
                    AERecord.saveAndWait()
                    self.showFriends()
                }
            }
        }
    }
    
    func showChat(friend: CDFriend) {
        let chat = Chat()
        chat.type = "text"
        chat.targetId = friend.email!
        chat.chatId = SessionHelper.instance.email! + "&" + chat.targetId
        chat.title = friend.firstName! + " " + friend.lastName!
        chat.detail = "bot"
        let chatVC = MMChatViewController(chat: chat)
        chatVC.friend = friend
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (friendsArray?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let friend = friendsArray[indexPath.row]
        let name = friend.firstName! + " " + friend.lastName!
        let avatarImg = WSHelper.getBaseURL() + friend.avatarImage!
        cell.avatarImageView.kf.setImage(with: URL(string: avatarImg), placeholder: #imageLiteral(resourceName: "ic_exhibi"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.avatarImageView.layer.cornerRadius = 25
        cell.avatarImageView.clipsToBounds = true
        cell.countryLabel.text = friend.receiver
        cell.nameLabel.text = name.capitalized
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsArray[indexPath.row]
        showChat(friend:friend)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: QR Reader Delegate
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        reader.dismiss(animated: true) {
            if result.value.isValidMail() {
                SVProgressHUD.show(withStatus: "Please wait...")
                WSHelper.sharedInstance.addFriend(receiver: result.value, sender: SessionHelper.instance.email!) { (result, error) in
                    if (error == nil) {
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self.fetchFriends()
                    } else {
                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    
}
