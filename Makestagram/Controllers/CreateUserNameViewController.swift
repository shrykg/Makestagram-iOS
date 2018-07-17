//
//  CreateUserNameViewController.swift
//  Makestagram
//
//  Created by Shreyak Godala on 25/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateUserNameViewController: UIViewController {

   @IBOutlet weak var nextButton: UIButton!
   @IBOutlet weak var usernameTextfield: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nextButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nexttapped(_ sender: UIButton) {
        
        guard let firUser = Auth.auth().currentUser,
          let username = usernameTextfield.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            User.setUser(user, writeToUserDefaults: true)
            
            print("Created New user: \(user.username)")
        }
        
        let initialViewController = UIStoryboard.initialViewController(for: .main)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
        
        
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
