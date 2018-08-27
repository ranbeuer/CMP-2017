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

class ContactsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showChat(friend: CDFriend) {
        let chat = ContactsViewController.botChat
        var chatVC = MMChatViewController(chat: chat)
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
    
    
}
