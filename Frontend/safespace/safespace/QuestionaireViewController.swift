//
//  ViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-02-02.
//

import UIKit



class QuestionaireViewController: UIViewController {
    
    var mentorStarter = "Have you experienced symtoms of any "
    var menteeStarter = "Are you experiencing symptoms of any "

    
    var illnessArray = ["mood disorders such as depression", "anxiety disorders", "eating disorders", "trauma-related disorders","impulse-control disorders", "psychotic disorders", "personality disorders", "addiction and substance abuse disorders"]
    
    var moodSpecific = ["Depression", "Bipolar Disorder", "Postpartum Depression", "Premenstrual Dysphoric Disorder"]
    
    var anxietySpecific = ["General Anxiety", "Obsessive-Compulsive Disorder", "Panic Disorder", "Phobias", "Agoraphobia", "Social Anxiety"]
    
    var eatingSpecific = ["Anorexia", "Bulimia", "Binge Eating"]
    
    var traumaSpecific = ["Post-Traumatic Stress Disorder", "Acute Stress Disorder"]
    
    var impulseSpecific = ["Kleptomania", "Pyromania", "Intermittent Explosive Disorder"]
    
    var psychoticSpecific = ["Schizophrenia", "Schizoaffective Disorder", "Brief Psychotic Disorder"]
    
    var personalitySpecific = ["Narcissistic", "Borderline", "Avoidant", "Paranoid", "Dependent"]
    
    var substanceSpecific = ["Alcohol", "Illegal Substances", "Prescription Drugs"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        isModalInPresentation = true
       
        if(Globals.questionaireLevel<=7){
            Globals.questionaireLevel = Globals.questionaireLevel + 1
            self.questionText.text = labelBuilder()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        if(Globals.questionaireLevel > 7){
            goToBioPage()
        }
    }
    
    func labelBuilder() -> String{
        var label = ""
        if(Payload.userType == "mentor") {
            label = mentorStarter + illnessArray[Globals.questionaireLevel] + "?"
        } else {
            label = menteeStarter + illnessArray[Globals.questionaireLevel] + "?"
        }
        return label
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Globals.colorTop, Globals.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func goToBioPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setProfileViewController = storyBoard.instantiateViewController(withIdentifier: "profile") as! SetProfileViewController
        setProfileViewController.modalPresentationStyle = .fullScreen
        self.present(setProfileViewController, animated: true, completion: nil)
       
    }
    
    
    func nextPage(){
       
        self.navigationController?.pushViewController(self, animated: true)
        if(Globals.questionaireLevel<=6){
            Globals.questionaireLevel = Globals.questionaireLevel + 1
            self.questionText.text = labelBuilder()
        } else {
            goToBioPage()
        }
        
        
    }

    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var questionText: UILabel!
    
    
    @IBAction func yesButton(_ sender: Any) {
        
    }
    
    @IBAction func noButton(_ sender: Any) {
        nextPage()
    }
    
    @IBAction func preferNotToSayButton(_ sender: Any) {
        nextPage()
    }
}

