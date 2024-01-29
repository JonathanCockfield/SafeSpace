//
//  ProfileViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-04.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        isModalInPresentation = true
        // Do any additional setup after loading the view.
        self.nameTitle.text = Payload.retrievedFirstName
        self.biographyText.text = Payload.retrievedBio
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var biographyText: UITextView!
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
  
}
