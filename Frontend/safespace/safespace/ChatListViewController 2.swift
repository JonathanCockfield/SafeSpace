//
//  ChatListViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-04.
//

import Foundation
import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Jack"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = MessagingViewController()
        VC.title = "Chat"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    @IBOutlet weak var chatTableView: UITableView!
    
   
    
}
