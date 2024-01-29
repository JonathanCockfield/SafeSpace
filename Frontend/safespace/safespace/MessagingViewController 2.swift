//
//  MessagingViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-01.
//

import Foundation

import UIKit
import MessageKit
import InputBarAccessoryView
//import MessageInputBar




struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
}

struct Message: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}

class MessagingViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "Jack")
    let otherUser = Sender(senderId: "other", displayName: "Mr. McPherson")

    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setGradientBackground()
        isModalInPresentation = true
        // Do any additional setup after loading the view.
        
//        messages.append(Message(sender: otherUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hi i have cancer")))
//
//        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("Hello im mr mcpherson haha")))
//
//        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-60000), kind: .text("...")))
//
//        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-50000), kind: .text("u bald yet? xD jk")))
//
//        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-40000), kind: .text("bro")))
//        messages.append(Message(sender: otherUser, messageId: "6", sentDate: Date().addingTimeInterval(-30000), kind: .text("add my psn McPhersonFux96")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
    
//        messagesCollectionView.messagesDisplayDelegate?.backgroundColor(for: MessageType, at: IndexPath, in: MessagesCollectionView) = Globals.colorTopp
//
       

    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func createMessage(userId: String, messageId: String, sentDate: String, messageText: String) {
        var sender = Sender(senderId: "", displayName: "")
        if(userId == Payload.id){
            sender = Sender(senderId: "self", displayName: "")
        } else {
            sender = Sender(senderId: "other", displayName: "")
        }
        
        let message = Message(sender: sender, messageId: messageId, sentDate: Date().addingTimeInterval(-40000), kind: .text(messageText))
        print("final butt")
        print(message)
        print("oncingberg")

        messages.append(message)
        
        self.messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        
    }
    
    
    
    
   
}

extension MessagingViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        DispatchQueue.main.async {
            Store().sendMessage(id: Payload.chatRoomId, message: text)
        }
        self.messagesCollectionView.reloadData()
        
        self.messagesCollectionView.scrollToLastItem(animated: true)
        
//        self.messageInputBar. = ""
        
        
    }

    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }

}




