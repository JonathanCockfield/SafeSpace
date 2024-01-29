//
//  UserTypeViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-02.
//

import Foundation
import UIKit

class UserTypeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        isModalInPresentation = true
        // Do any additional setup after loading the view.
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func mentorButton(_ sender: Any) {
        Payload.userType = "mentor"
//        Store().getMessages(id: Payload.chatRoomId)
       
    }
    
    @IBAction func menteeButton(_ sender: Any) {
        Payload.userType = "mentee"
    }
}
