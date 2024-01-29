//
//  HomePageViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-04.
//

import Foundation
import UIKit

class HomePageViewController: UIViewController {
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
    
    func setButtons() {
        self.goToHome.layer.borderWidth = 2
        self.goToHome.layer.borderColor = Globals.colorBottom
        self.goToHome.setTitleColor( UIColor(cgColor:Globals.colorBottom), for: .normal)
        self.goToMessages.layer.borderWidth = 1
        self.goToMessages.layer.borderColor = Globals.colorBottom
        self.goToMessages.setTitleColor( UIColor(cgColor:Globals.colorBottom), for: .normal)
        self.goToProfile.layer.borderWidth = 1
        self.goToProfile.layer.borderColor = Globals.colorBottom
        self.goToProfile.setTitleColor( UIColor(cgColor:Globals.colorBottom), for: .normal)
    }
    @IBOutlet weak var goToMessages: UIButton!
    
    @IBOutlet weak var goToHome: UIButton!
    
    @IBOutlet weak var goToProfile: UIButton!
}
