//
//  TravelGuideFeedVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/16/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class TravelGuideFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cityPosts = [CityPost]()
    
    lazy var cityPostImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "downvote")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var cityPostText: String = ""
    let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        getCityPosts()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func randomFunc(ref: DatabaseReference, completion: @escaping (Int) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                completion(Int(snapshot.childrenCount))
            })
        }
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let posts: [CityPost] = snapshot.reversed().flatMap{
                guard let post = CityPost(snapshot: $0)
                    else {return nil}
                
                post.isUpvoted = false
                post.isDownvoted = false

                return post
            }
            
            self.cityPosts = posts
        })
    }
    
    
    func getCityPosts() {
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
//                return
//            }
//            
//            let posts: [CityPost] = snapshot.reversed().flatMap{
//                guard let post = CityPost(snapshot: $0)
//                    else {return nil}
//                
//                return post
//            }
//            
//            self.cityPosts = posts
//        })
        
        let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
        
        cityPosts.removeAll()
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let dispatchGroup = DispatchGroup()
            var posts = [CityPost]()
            guard let post = CityPost(snapshot: snapshot)
                else {return }
            
            if let imageURL = URL(string: post.imageUrl) {
                dispatchGroup.enter()
                URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    
                    guard let imgData = data
                        else {
                            dispatchGroup.leave()
                            return
                    }
                    
                    post.image = UIImage(data: imgData)
                    
                    dispatchGroup.leave()
                    
                }).resume()
            }
            //                return post
            //            }
            dispatchGroup.notify(queue: .main, execute: {
                posts.append(post)
                self.cityPosts.append(post)
                var total = 0
                
                self.randomFunc(ref: ref, completion: { (total) in
                    if self.cityPosts.count == total {
                        self.cityPosts.reverse()
                        self.tableView.reloadData()
                    }
                })
                
            })
        })
    }
}


extension TravelGuideFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = cityPosts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            
            if let _ = URL(string: post.imageUrl){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedImageCell", for: indexPath) as! ExploreFeedImageCell
                
                cell.postTextLabel.text = post.text
                cell.postImage.image = post.image!
                print("Image cell: \(indexPath.section)")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedTextCell", for: indexPath) as! ExploreFeedTextCell
                cell.postTextLabel.text = post.text
                print("text cell")
                return cell
            }
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedFooterCell", for: indexPath) as! ExploreFeedFooterCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func configureCell(_ cell: ExploreFeedFooterCell, with post: CityPost) {
        
        cell.postedByLabel.text = "By: \(post.postByName)"
        cell.upvoteCountLabel.text = "\(post.upvoteCount)"
        cell.downvoteLabel.text = "\(post.downvoteCount)"
        
        
        VoteService.isPostDownvoted(post, byCurrentUserWithCompletion: { (isDownvoted) in
            cell.downvoteButton.isSelected = isDownvoted
            cell.downvoteButton.isUserInteractionEnabled = !isDownvoted
        })
        
        VoteService.isPostUpvoted(post, byCurrentUserWithCompletion: { (isUpvoted) in
            cell.upvoteButton.isSelected = isUpvoted
            cell.upvoteButton.isUserInteractionEnabled = !isUpvoted
        })
        
    }
    
    func configureSingleCell(_ cell: ExploreFeedFooterCell, with post: CityPost) {

        cell.postedByLabel.text = "By: \(post.postByName)"
        cell.upvoteCountLabel.text = "\(post.upvoteCount)"
        cell.downvoteLabel.text = "\(post.downvoteCount)"
        
        
        VoteService.isPostDownvoted(post, byCurrentUserWithCompletion: { (isDownvoted) in
            cell.downvoteButton.isSelected = isDownvoted
            cell.downvoteButton.isUserInteractionEnabled = !isDownvoted
        })
        
        VoteService.isPostUpvoted(post, byCurrentUserWithCompletion: { (isUpvoted) in
            cell.upvoteButton.isSelected = isUpvoted
            cell.upvoteButton.isUserInteractionEnabled = !isUpvoted
        })
        
//        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityPosts.count
    }
    
}

extension TravelGuideFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 100
            
        case 1:
            return 200
            
        case 2:
            return 90
            
        default:
            fatalError("Error: unexpected height.")
        }
    }
}

extension TravelGuideFeedVC: ExploreFeedFooterCellDelegate {
    func didTapUpvoteButton(_ likeButton: UIButton, on cell: ExploreFeedFooterCell) {
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        likeButton.isUserInteractionEnabled = false
        
        let post = cityPosts[indexPath.section]
        
        DispatchQueue.global(qos: .userInitiated).async {
            VoteService.setIsUpvoted(!post.isUpvoted, for: post) { (success) in
     
                guard success else { return }
                
                DispatchQueue.main.async {
                    self.configureSingleCell(cell, with: post)
                }
            }
        }
    }
    
    func didTapDownvoteButton(_ downvoteButton: UIButton, on cell: ExploreFeedFooterCell) {
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        downvoteButton.isUserInteractionEnabled = false
        
        let post = cityPosts[indexPath.section]
        
        DispatchQueue.global(qos: .userInitiated).async {
            VoteService.setIsDownvoted(!post.isDownvoted, for: post) { (success) in
                
                guard success else { return }
                
                DispatchQueue.main.async {
                    self.configureSingleCell(cell, with: post)
                }
            }
        }
    }
    
    func updateSingleCell(on cell: ExploreFeedFooterCell) {
        
    }

}


