//
//  ViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-02-02.
//

import UIKit



class ConditionViewController: UIViewController {
    
   
    var moodSpecific = ["Depression", "Bipolar Disorder", "Postpartum Depression", "Premenstrual Dysphoric Disorder"]
    
    var anxietySpecific = ["General Anxiety", "Obsessive-Compulsive Disorder", "Panic Disorder", "Phobias", "Agoraphobia", "Social Anxiety"]
    
    var eatingSpecific = ["Anorexia", "Bulimia", "Binge Eating"]
    
    var traumaSpecific = ["Post-Traumatic Stress Disorder", "Acute Stress Disorder"]
    
    var impulseSpecific = ["Kleptomania", "Pyromania", "Intermittent Explosive Disorder"]
    
    var psychoticSpecific = ["Schizophrenia", "Schizoaffective Disorder", "Brief Psychotic Disorder"]
    
    var personalitySpecific = ["Narcissistic", "Borderline", "Avoidant", "Paranoid", "Dependent"]
    
    var substanceSpecific = ["Alcohol", "Illegal Substances", "Prescription Drugs"]
    
    var specificArray = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        isModalInPresentation = true
        self.specificArray = [moodSpecific, anxietySpecific, eatingSpecific, traumaSpecific, impulseSpecific, psychoticSpecific, personalitySpecific, substanceSpecific]
        setButtons()
        // Do any additional setup after loading the view.
        
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
   
    @IBOutlet weak var buttonStack: UIStackView!
    
    func setButtons(){

        for title in self.specificArray[Globals.questionaireLevel] {
           createButton(title: title)
        }
       
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        if(sender.backgroundColor == .clear) {
            sender.backgroundColor = .white
            sender.setTitleColor(UIColor(cgColor:Globals.colorTop), for: .normal)
            Payload.conditions.append(sender.titleLabel!.text!)

        }
        else {
            sender.backgroundColor = .clear
            sender.setTitleColor(.white, for: .normal)
            let int = Payload.conditions.firstIndex(of: (sender.titleLabel!.text!))!
            Payload.conditions.remove(at: int)
        }
        
      
    }
    
    func createButton( title: String){
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.buttonStack.alignment = .fill
        self.buttonStack.distribution = .fillEqually
        self.buttonStack.spacing = 20.0
        self.buttonStack.addArrangedSubview(button)
    }
   
}

