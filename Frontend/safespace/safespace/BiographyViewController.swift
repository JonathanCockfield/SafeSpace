//
//  ViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-02-02.
//

import UIKit

class BiographyViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        isModalInPresentation = true
        self.biographyTitle.text = labelBuilder()
        self.modalPresentationStyle = .fullScreen
        self.biography!.layer.borderWidth = 1
        self.biography!.layer.borderColor = UIColor.white.cgColor
        self.biography!.layer.cornerRadius = 20
//        registerTap()
        // Do any additional setup after loading the view.
    }
    
//    func registerTap() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tap.delegate = self
//        self.biography.delegate = self
//        self.biography!.isUserInteractionEnabled = true
//        self.biography!.addGestureRecognizer(tap)
//        self.biography!.isSelectable = true
//        self.biography!.isEditable = true
//    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if(self.biography!.text == "Describe yourself in detail here...") {
            self.biography!.text = ""
        }
    }
    
    func setGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func labelBuilder() -> String{
        var label = ""
        if(Payload.userType == "Mentor") {
            label = "Help your mentee understand you better"
        } else {
            label = "Help your mentor understand you better"
        }
        return label
    }
    @IBOutlet weak var biographyTitle: UILabel!
    
    @IBOutlet weak var biography: UITextView!
    
    @IBAction func `continue`(_ sender: Any) {
        Payload.bio = self.biography.text
        Payload.initiateChat = true
        DispatchQueue.main.async {
            Store().createUser()
        }
        if(Payload.userType == "mentee") {
            DispatchQueue.main.async {
                Store().match()
            }
            
        }
    }
}

