//
//  FindFriendsViewController.swift
//  Makestagram
//
//  Created by Shreyak Godala on 26/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {

    
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FindFriendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell", for: indexPath) as! FindFriendsCell
        
        cell.delegate = self
        
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
        
    }
    
    func configure(cell: FindFriendsCell, atIndexPath indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
        cell.followButton.isSelected = user.isFollowed
        
    }
    
    
}


extension FindFriendsViewController: FindFriendsCellDelegate {
    
    
    
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell) {
        guard let indexpath = tableView.indexPath(for: cell) else {return}
        
        followButton.isUserInteractionEnabled = false
        
        let followe = users[indexpath.row]
        
        FollowService.setIsFollowing(!followe.isFollowed, fromCurrentUserTo: followe) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            
            followe.isFollowed = !followe.isFollowed
            
            self.tableView.reloadRows(at: [indexpath], with: .none)
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
}




