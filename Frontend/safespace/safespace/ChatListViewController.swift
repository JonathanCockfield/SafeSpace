//
//  ChatListViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-04.
//

import Foundation
import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var name = ""
    var names = [String]()
    var matchNames = [String]()
    var chatRooms = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        chatTableView.delegate = self
        chatTableView.dataSource = self
        if(self.names.isEmpty){
            getProfile()
            getChatRooms()
        }

        DispatchQueue.main.async {
            if(!self.names.isEmpty){
                Store().getProfileNames(ids: self.names)
            }
        }
        let play = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(playTapped))

        navigationItem.rightBarButtonItems = [play]
    }
    @objc func playTapped(_ sender: UIBarButtonItem) {
        goToHomePage()
    }
    
    func goToHomePage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePageViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomePageViewController
        homePageViewController.modalPresentationStyle = .fullScreen
        self.present(homePageViewController, animated: true, completion: nil)
    }
        
    func getProfile() {
        for item in Payload.matches{
            if item is NSNull {
               print("null")
            } else {
                let id = item as! String
                self.names.append(id)
            }
        }
    }
    
    func getChatRooms() {
        for item in Payload.chatRoomIds{
            if item is NSNull {
               print("null")
            } else {
                
                let id = item as! String
                self.chatRooms.append(id)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("we here")
        if(self.matchNames.isEmpty){
            setArray()
        }
    }
    
    func setArray() {
        for item in Payload.matchObjects {
            
            self.matchNames.append(item["firstName"] as! String)
        }
        chatTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.matchNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.matchNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = MessagingViewController()
        VC.title = self.matchNames[indexPath.row]

        Payload.chatRoomId = self.chatRooms[indexPath.row]

        Store().getMessages(id: self.chatRooms[indexPath.row])
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    @IBOutlet weak var chatTableView: UITableView!
    
   
    
}
