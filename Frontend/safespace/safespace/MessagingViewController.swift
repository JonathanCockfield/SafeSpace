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
    
    let currentUser = Sender(senderId: "self", displayName: "")
    let otherUser = Sender(senderId: "other", displayName: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setGradientBackground()
        isModalInPresentation = true
        // Do any additional setup after loading the view.
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.loadChat()
        }
        group.notify(queue: .main) {
            
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
    
//        messagesCollectionView.messagesDisplayDelegate?.backgroundColor(for: MessageType, at: IndexPath, in: MessagesCollectionView) = Globals.colorTopp
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            self.loadChat()
            print("bingus")
        }
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
        return Globals.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return  Globals.messages.count
    }
    
    
    
    func loadChat() {

            Store().getMessages(id: Payload.chatRoomId)
        

            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        
      
        print("message count:")
        print(Globals.messages.count)
        print("messages loaded")
    }
    func createMessage(userId: String, messageId: String, sentDate: String, messageText: String) -> MessageType{
        var sender = Sender(senderId: "", displayName: "")
        if(userId == Payload.id){
            sender = Sender(senderId: "self", displayName: "")
        } else {
            sender = Sender(senderId: "other", displayName: "")
        }
        
        let message = Message(sender: sender, messageId: messageId, sentDate: Date().addingTimeInterval(-40000), kind: .text(messageText))
       

        return message
    }
    
    
    
    
    
    
   
}

extension MessagingViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
//        messages.append(Message(sender: otherUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text(text)))
        
        
//        DispatchQueue.main.async {
//        }
        //
        Globals.messages.append(Message(sender: Sender(senderId: "self", displayName: ""), messageId: "", sentDate: Date().addingTimeInterval(-40000), kind: .text(text)))
        
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        
        Store().sendMessage(id: Payload.chatRoomId, message: text)
        
        

        
        
        
        
//        self.messageInputBar. = ""
        
        inputBar.inputTextView.text = ""
        
    }

    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }

}




