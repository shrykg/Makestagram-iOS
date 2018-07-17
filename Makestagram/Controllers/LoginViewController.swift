//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Shreyak Godala on 24/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase


typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        
        guard let authUI = FUIAuth.defaultAuthUI()
            
         else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        
        present(authViewController, animated: true)
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: FUIAuthDelegate {



    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }

        // 1
       guard let user = user
           else { return }

        // 2
        //let userRef = Database.database().reference().child("users").child(user.uid)

        // 3
        UserService.show(forUID: user.uid) { (user) in
            // 4 retrieve user data from snapshot

            if let user = user {
                
                // Handle existing user
                
                User.setUser(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()


                print("Welcome \(user.username)")
            } else {
                
                // Handle new user
                print("New user!")
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }


        }
        
//        UserService.show(forUID: user.uid) { (user) in
//            if let user = user {
//                // handle existing user
//                User.setCurrent(user)
//
//                let storyboard = UIStoryboard(name: "Main", bundle: .main)
//                if let initialViewController = storyboard.instantiateInitialViewController() {
//                    self.view.window?.rootViewController = initialViewController
//                    self.view.window?.makeKeyAndVisible()
//                }
//            } else {
//                // handle new user
//                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
//            }
//        }
    }
    }

















