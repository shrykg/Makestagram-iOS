//
//  ProfileViewController.swift
//  Makestagram
//
//  Created by Shreyak Godala on 16/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var user: User!
    
    var posts = [Post]()
    
    var profileHandle: DatabaseHandle = 0
    
    var profileRef : DatabaseReference?
    
    
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        user = user ?? User.current
        navigationItem.title = user.username
        
        profileHandle = UserService.observeProfile(for: user, completion: { [unowned self] (ref, user, posts) in
            self.profileRef = ref
            self.user = user
            self.posts = posts
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        })
        
        
        
        
        
    }
    
    deinit{
        profileRef?.removeObserver(withHandle: profileHandle)
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


extension ProfileViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumpImageCell", for: indexPath) as! PostThumpImageCell
        let post = posts[indexPath.row]
        let imageURL = URL(string: post.imageURL)
        
        cell.postImage.kf.setImage(with: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("unexpected element kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        
        let postCount = user.postCount ?? 0
        headerView.postCountLabel.text = "\(postCount)"
        
        let followerCount = user.followerCount ?? 0
        headerView.followerCountLabel.text = "\(followerCount)"
        
        let followingCount = user.followingCount ?? 0
        headerView.followingCountLabel.text = "\(followingCount)"
        
        return headerView
        
        
    }
    
    
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3
        
        let spacing: CGFloat = 1.5
        
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth: CGFloat = (collectionView.bounds.width - totalHorizontalSpacing) / 3
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    
    
    
    
    
    
    
    
}










