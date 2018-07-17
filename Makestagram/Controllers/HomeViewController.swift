//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Shreyak Godala on 26/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    
    
    
    // MARK:- Properties
    
    var posts = [Post]()
    
    
    let refreshControl = UIRefreshControl()
    
    let timeStampFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
        
        
        
        
    }()
    
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        reloadTimeline()
        
        
    }
    
    @objc func reloadTimeline() {
        
        UserService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                
                self.refreshControl.endRefreshing()
                
                
                
            }
            
            self.tableView.reloadData()
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        
        // remove separators from empty cells
        
        tableView.tableFooterView = UIView()
        
        // remove separators from cells
        
        tableView.separatorStyle = .none
        
        
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        
        
        
        
        
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

// MARK: UITableviewDatasource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
         
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell", for: indexPath) as! PostHeaderCell
            cell.usernameLabel.text = post.poster.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImage.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell", for: indexPath) as! PostActionCell
            
            cell.delegate = self
            
            configureCell(cell, for: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected index path")
            
        }
    }
    
    func configureCell(_ cell: PostActionCell, for post: Post) {
        
        cell.timeAgoLabel.text = timeStampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
        
        
    }
    
    
}

// MARK: UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
        case 2:
            return PostActionCell.height
        default:
            fatalError()
        }
        
        
    }
    
    
}


extension HomeViewController: PostActionCellDelegate {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        print("did tap like button")
    
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        likeButton.isUserInteractionEnabled = false
        
        let post = posts[indexPath.section]
        
        
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            defer {
                likeButton.isUserInteractionEnabled = false
            }
            
            guard success else {return}
            
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell else {return}
            
            DispatchQueue.main.async {
                self.configureCell(cell, for: post)
            }
            
            
        }
        
    
    }
    
    
}



