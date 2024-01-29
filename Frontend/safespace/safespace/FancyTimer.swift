////
////  FancyTimer.swift
////  safespace
////
////  Created by Jack Cockfield on 2021-03-05.
////
//
//import Foundation
//import SwiftUI
//import Combine
//import MessageKit
//import UIKit
//
//class FancyTimer: NSObject, ObservableObject {
//    @Published var MessageArray: [MessageType] = []
//
//    override init() {
//        let baseUrl = "https://35.209.161.199:3000"
//
//        var url = URL(string: (baseUrl + "/room/\(Payload.chatRoomId)"))!
//
//
//
//        var request = URLRequest(url: url)
//        var token = Payload.bearerToken
////        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        request.httpMethod = "GET"
//
//        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        var timer: Timer? = nil
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
//            timer in
//
//
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            let task = session.dataTask(with: request) { (data, response, error) in
//
//                if let error = error {
//                    // Handle HTTP request error
//                    print(error)
//                } else if let data = data {
//                    // Handle HTTP request response
//                    if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//
//                        if let response = try? responseJSON as? [String: Any] {
//                            let conversation = response["conversation"] as! [[String:Any]]
//    //                        print(conversation)
//                            var tempArray = [MessageType]()
//                            if(conversation.count > self.MessageArray.count){
//                                for item in conversation {
//                                    let postedByUser = item["postedByUser"] as? [String: Any]
//                                    let id = postedByUser!["_id"] as! String
//                                    let message = item["message"] as? [String: Any]
//                                    let messageText = message!["messageText"] as! String
//
//                                    tempArray.append(self.createMessage(userId: id, messageId: "", sentDate: "", messageText: messageText))
//                                    print(tempArray[0])
//
//                                }
//                                self.MessageArray = tempArray
//                                print(self.MessageArray[self.MessageArray.endIndex])
//                            }
//
//
//
//
//
//                        }
//                    }
//                } else {
//                    //
//                }
//            }
//
//            task.resume()
//
//        }
//    }
//    func createMessage(userId: String, messageId: String, sentDate: String, messageText: String) -> MessageType{
//        var sender = Sender(senderId: "", displayName: "")
//        if(userId == Payload.id){
//            sender = Sender(senderId: "self", displayName: "")
//        } else {
//            sender = Sender(senderId: "other", displayName: "")
//        }
//
//        let message = Message(sender: sender, messageId: messageId, sentDate: Date().addingTimeInterval(-40000), kind: .text(messageText))
//
//
//        return message
//    }
//}
//extension FancyTimer: URLSessionDelegate{ func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!)) } }
