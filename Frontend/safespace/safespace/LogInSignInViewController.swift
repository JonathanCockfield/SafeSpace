//
//  ViewController.swift
//  safespace
//
//  Created by Jack Cockfield on 2021-02-02.
//

import UIKit
import FirebaseAuth

class FirebaseAuthManager {
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                user.getIDTokenResult { (tokenId: AuthTokenResult?, error: Error?) in
                    guard let token = tokenId?.token
                    else {
                        print(error!)
                        return
                    }
                    let currentUser = Auth.auth().currentUser
                    currentUser?.getIDTokenForcingRefresh(true, completion: { (token: String?, error: Error?) in
                        Payload.bearerToken = token!
                        Payload.id = currentUser!.uid
                    })
                    Payload.bearerToken = token
                    Payload.id = user.uid
                    
                }
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let res = result {
                res.user.getIDTokenResult { (tokenId: AuthTokenResult?, error: Error?) in
                    guard let token = tokenId?.token
                    else {
                        print(error!)
                        return
                    }
                    let currentUser = Auth.auth().currentUser
                    currentUser?.getIDTokenForcingRefresh(true, completion: { (token: String?, error: Error?) in
                        Payload.bearerToken = token!
                        Payload.id = currentUser!.uid
                    })
                    Payload.bearerToken = token
                    Payload.id = res.user.uid
                }
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
}

class LogInSignInViewController: UIViewController {

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

    @IBAction func logIn(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        loginManager.signIn(email: Payload.email, pass: Payload.password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully logged in."
                    Payload.isNewUser = false
                    self.goToHomePage()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Your email or password is incorrect.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    message = "There was an error."
                }
            }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let signUpManager = FirebaseAuthManager()
        signUpManager.createUser(email: Payload.email, password: Payload.password) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message: String = ""
                    if (success) {
                        message = "User was sucessfully created."
                        Payload.isNewUser = true
                        self.goToUserTypePage()
                    } else {
                        let alert = UIAlertController(title: "Error", message: "You entered an invalid username or password.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        message = "There was an error."
                    }
            }
    }
    @IBAction func email(_ sender: UITextField) {
        Payload.email = sender.text!
        
    }
    @IBAction func password(_ sender: UITextField) {
        Payload.password = sender.text!
    }
    
    func goToUserTypePage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userTypeViewController = storyBoard.instantiateViewController(withIdentifier: "type") as! UserTypeViewController
        userTypeViewController.modalPresentationStyle = .fullScreen
        self.present(userTypeViewController, animated: true, completion: nil)
    }
    func goToHomePage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePageViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomePageViewController
        homePageViewController.modalPresentationStyle = .fullScreen
        self.present(homePageViewController, animated: true, completion: nil)
    }
    
}

