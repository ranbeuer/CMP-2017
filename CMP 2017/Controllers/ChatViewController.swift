//
//  ChatViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/17/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import NoChat

class MMChatViewController: NOCChatViewController, UINavigationControllerDelegate, MessageManagerDelegate, MMChatInputTextPanelDelegate, MMTextMessageCellDelegate {
    
    var messageManager = MessageManager.manager
    var layoutQueue = DispatchQueue(label: "com.little2s.nochat-example.mm.layout", qos: DispatchQoS(qosClass: .default, relativePriority: 0))
    
    let chat: Chat
    
    // MARK: Overrides
    
    override class func cellLayoutClass(forItemType type: String) -> Swift.AnyClass? {
        if type == "Text" {
            return MMTextMessageCellLayout.self
        } else if type == "Date" {
            return MMDateMessageCellLayout.self
        } else if type == "System" {
            return MMSystemMessageCellLayout.self
        } else {
            return nil
        }
    }
    
    override class func inputPanelClass() -> Swift.AnyClass? {
        return MMChatInputTextPanel.self
    }
    
    override func registerChatItemCells() {
        collectionView?.register(MMTextMessageCell.self, forCellWithReuseIdentifier: MMTextMessageCell.reuseIdentifier())
        collectionView?.register(MMDateMessageCell.self, forCellWithReuseIdentifier: MMDateMessageCell.reuseIdentifier())
        collectionView?.register(MMSystemMessageCell.self, forCellWithReuseIdentifier: MMSystemMessageCell.reuseIdentifier())
    }
    
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        isInverted = false
        chatInputContainerViewDefaultHeight = 50
        messageManager.addDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageManager.removeDelegate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backgroundView?.image = UIImage(named: "MMWallpaper")!
        navigationController?.delegate = self
        let rightItem = UIBarButtonItem(image: UIImage(named: "MMUserInfo"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightItem
        title = chat.title
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(white: 0.1, alpha: 0.9)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.tintColor = nil
        super.viewWillDisappear(animated)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView && scrollView.isTracking {
            inputPanel?.endInputting(true)
        }
    }
    
    // MARK: MMChatInputTextPanelDelegate
    
    func didInputTextPanelStartInputting(_ inputTextPanel: MMChatInputTextPanel) {
        if isScrolledAtBottom() == false {
            scrollToBottom(animated: true)
        }
    }
    
    func inputTextPanel(_ inputTextPanel: MMChatInputTextPanel, requestSendText text: String) {
        let msg = Message()
        msg.text = text
        sendMessage(msg)
    }
    
    // MARK: MMTextMessageCellDelegate
    
    func didTapLink(cell: MMTextMessageCell, linkInfo: [AnyHashable: Any]) {
        inputPanel?.endInputting(true)
        
        guard let command = linkInfo["command"] as? String else { return }
        let msg = Message()
        msg.text = command
        sendMessage(msg)
    }
    
    // MARK: MessageManagerDelegate
    
    func didReceiveMessages(messages: [Message], chatId: String) {
        if isViewLoaded == false { return }
        
        if chatId == chat.chatId {
            addMessages(messages, scrollToBottom: true, animated: true)
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is ContactsViewController else {
            return
        }
        
        isInControllerTransition = true
        
        guard let tc = navigationController.topViewController?.transitionCoordinator else { return }
        tc.notifyWhenInteractionEnds { [weak self] (context) in
            guard let strongSelf = self else { return }
            if context.isCancelled {
                strongSelf.isInControllerTransition = false
            }
        }
    }
    
    // MARK: Private
    
    private func loadMessages() {
        layouts.removeAllObjects()
        
        messageManager.fetchMessages(withChatId: chat.chatId) { [weak self] (msgs) in
            if let strongSelf = self {
                strongSelf.addMessages(msgs, scrollToBottom: true, animated: false)
            }
        }
    }
    
    private func sendMessage(_ message: Message) {
        message.isOutgoing = true
        message.senderId = User.currentUser.userId
        message.deliveryStatus = .Read
        
        addMessages([message], scrollToBottom: true, animated: true)
        
        messageManager.sendMessage(message, toChat: chat)
    }
    
    private func addMessages(_ messages: [Message], scrollToBottom: Bool, animated: Bool) {
        layoutQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let count = strongSelf.layouts.count
            let indexes = IndexSet(integersIn: count..<count+messages.count)
            
            var layouts = [NOCChatItemCellLayout]()
            
            for message in messages {
                let layout = strongSelf.createLayout(with: message)!
                layouts.append(layout)
            }
            
            DispatchQueue.main.async {
                strongSelf.insertLayouts(layouts, at: indexes, animated: animated)
                if scrollToBottom {
                    strongSelf.scrollToBottom(animated: animated)
                }
            }
        }
    }
    
}


