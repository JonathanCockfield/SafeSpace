//
//  Store.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-02-28.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import MessageKit


struct Globals {
    static var questionaireLevel = -1
    static var colorTop =  UIColor(red: 5.0/255.0, green: 53.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor
    static var colorBottom = UIColor(red: 109.0/255.0, green: 211.0/255.0, blue: 216.0/255.0, alpha: 1.0).cgColor
    static var messages = [MessageType]()
}

struct Payload {
    static var conditions = [String]()
    static var bio = String()
    static var email = String()
    static var password = String()
    static var userType = String()
    static var firstName = String()
    static var lastName = String()
    static var messages = [String]()
    static var chatRoomId = String()
    static var id = "ee96cc96996e44028e9aa0722c99e6e5"
    static var bearerToken = String()
    static var age = String()
    static var isNewUser = Bool()
    static var matchId = String()
    static var retrievedFirstName = String()
    static var retrievedBio = String()
    static var matches = NSArray()
    static var matchNames = [String]()
    static var initiateChat = false
    static var matchObjects = [[String:Any]]()
    static var initialOpen = false
    static var chatRoomIds = NSArray()
}

class Store: NSObject {
    let baseUrl = "https://35.209.161.199:3000"
    
    func inititiateChatRoom() {
        let url = URL(string: (baseUrl + "/room/initiate"))!
        var request = URLRequest(url: url)
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
    
        let body = ["userIds": [Payload.matchId], "type": "consumer-to-consumer"] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
      

        // Change the URLRequest to a POST request
        request.httpBody = bodyData
        
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let chatRoom = try? responseJSON["chatRoom"] as? [String: Any] {
                        Payload.chatRoomId = chatRoom["chatRoomId"]! as! String
                    }
                }
            } else {
                print("get fucked")
            }
        }
        task.resume()

    }
    
    func sendMessage(id: String, message: String) {
        let url = URL(string: (baseUrl + "/room/\(id)/message"))!
        var request = URLRequest(url: url)
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ["messageText": message] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
      

        // Change the URLRequest to a POST request
        request.httpBody = bodyData
        
        
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

//                    }
                }
            } else {
                //
            }
        }
        task.resume()
        
    }
    
    func getMessages(id: String) {
        print("in getMessages")
        var url = URL(string: (baseUrl + "/room/\(id)"))!

        
        
        var request = URLRequest(url: url)
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "GET"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
    
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
//        var conversation = "" as! String
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let response = try? responseJSON as? [String: Any] {
                        let conversation = response["conversation"] as! [[String:Any]]
//                        print(conversation)
                        var tempArray = [MessageType]()
                        for item in conversation {
                            let postedByUser = item["postedByUser"] as? [String: Any]
//                            let messageId = item["_id"] as! String
                            let id = postedByUser!["_id"] as! String
//                            let date = item["createdAt"] as! String
                            let message = item["message"] as? [String: Any]
                            let messageText = message!["messageText"] as! String

                            tempArray.append(self.createMessage(userId: id, messageId: "", sentDate: "", messageText: messageText))
                            print(tempArray[0])
                           
                        }
                       
                        Globals.messages = tempArray
                        
                        
                    
                    }
                }
            } else {
                //
            }
        }
        
        task.resume()
    }
    
    func createUser() {
        let url = URL(string: (baseUrl + "/users"))!
        var request = URLRequest(url: url)
        
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        let body = ["firstName": Payload.firstName, "lastName": Payload.lastName, "age": Payload.age, "illness": Payload.conditions, "biography": Payload.bio, "type": Payload.userType] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )

      

        // Change the URLRequest to a POST request
        request.httpBody = bodyData
        
        
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let response = try? responseJSON as? [String: Any] {
                        print("success")
                    }
                }
            } else {
               print("sheet")
            }
        }
        task.resume()
    }
    func match() {
        let url = URL(string: (baseUrl + "/match"))!
        var request = URLRequest(url: url)
        
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        let body = ["illness": Payload.conditions] as [String : Any]
       
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
       
      

        // Change the URLRequest to a POST request
        request.httpBody = bodyData
        
        
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let response = try? responseJSON as? [String: Any] {
                        print("success")
                        let match = response["newMatch"] as? [String: Any]
                        print(response)
                        Payload.matchId = match!["_id"] as! String
                    }
                }
            } else {
               print("sheet")
            }
        }
        task.resume()
    }
    func getProfile(id: String) {
        let url = URL(string: (baseUrl + "/users/" + id))!
        
        print(url)
        var request = URLRequest(url: url)
        
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
    


        request.httpMethod = "GET"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        print("1")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        print("2")

        let task = session.dataTask(with: request) { (data, response, error) in
            print("3")

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let response = try? responseJSON as? [String: Any] {
                        print("goteem")
                        print(response)
                        let user = response["user"] as? [String: Any]
                        
                        Payload.retrievedBio = user!["biography"] as! String
                        Payload.matches = user!["matches"] as! NSArray
                        Payload.chatRoomIds =  user!["chatrooms"] as! NSArray
                        if(Payload.retrievedFirstName == "") {
                            Payload.retrievedFirstName = user!["firstName"] as! String
                        } else {
                            Payload.matchNames.append(user!["firstName"] as! String)
                        }
                        
                    }
                }
            } else {
               print("sheet")
            }
        }
        task.resume()
//        return responseValue!
    }
    
    func getProfileNames(ids: [String]) {
        let url = URL(string: (baseUrl + "/users/names"))!
        
        print("ids: ")
        print(ids)
        var request = URLRequest(url: url)
        
        
        
        var token = Payload.bearerToken
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
    


        request.httpMethod = "POST"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["userIds": ids] as [String : Any]
    
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
     
      

        // Change the URLRequest to a POST request
        request.httpBody = bodyData
        
        
        
        print("1")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        print("2")

        let task = session.dataTask(with: request) { (data, response, error) in
            print("3")

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let response = try? responseJSON as? [String: Any] {
                        print("profile names:")
                        print(response["users"])
            
                        Payload.matchObjects = ((response["users"] as? [[String:Any]])!)
                    }
                }
            } else {
               print("sheet")
            }
        }
        task.resume()
//        return responseValue!
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
extension Store: URLSessionDelegate{ func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!)) } }


