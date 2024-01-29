//
//  SetProfilePageViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-03-04.
//

import Foundation
import UIKit

class SetProfileViewController: UIViewController {
        
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
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    func goToBioPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let biographyViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! BiographyViewController
        biographyViewController.modalPresentationStyle = .fullScreen
        self.present(biographyViewController, animated: true, completion: nil)
       
    }
    
    @IBAction func `continue`(_ sender: Any) {
        var valid = false
        if(!firstName.hasText){
            let alert = UIAlertController(title: "Error", message: "Please be sure to fill in your first name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true)
            valid = false
        } else {
            Payload.firstName = firstName.text!
            Payload.lastName = lastName.text ?? ""
            valid = true
        }
        if(!age.hasText) {
            let alert = UIAlertController(title: "Error", message: "Please be sure to fill in your age.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true)
            valid = false
        } else {
            Payload.age = age.text!
            valid = true
        }
        if (valid == true) {
            goToBioPage()
        }
        
    }
    
}
