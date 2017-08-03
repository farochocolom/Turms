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
    
        let dispatchGroup = DispatchGroup()
        var newPosts = [CityPost]()

        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)

                guard let post = CityPost(snapshot: snapshot)
                    else {return}
                
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
                
                
               newPosts.append(post)
            dispatchGroup.notify(queue: .main, execute: {
                self.cityPosts = newPosts.reversed()
                self.tableView.reloadData()
            })
        })
    }

    func randomFunc(ref: DatabaseReference, completion: @escaping (Int) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                completion(Int(snapshot.childrenCount))
            })
        }
    }
    
    func getCityPosts() {
        
        let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dispatchGroup = DispatchGroup()
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let posts: [CityPost] = snapshot.reversed().flatMap {
                guard let post = CityPost(snapshot: $0)
                    else {return nil}
                
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
                return post
            }
            dispatchGroup.notify(queue: .main, execute: {
                self.cityPosts = posts
                self.tableView.reloadData()
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
        
        if post.tags.count == 1 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.alpha = 0.0
            cell.thirdTag.alpha = 0.0
        } else if post.tags.count == 2 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.text = post.tags[1]
            cell.secondTag.alpha = 1.0
            cell.thirdTag.alpha = 0.0
        } else if post.tags.count == 3 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.text = post.tags[1]
            cell.thirdTag.text = post.tags[2]
            cell.secondTag.alpha = 1.0
            cell.thirdTag.alpha = 1.0
        }
        
    }
    
    func configureSingleCell(_ cell: ExploreFeedFooterCell, with post: CityPost, index: Int) {
        
        VoteService.isPostDownvoted(post, byCurrentUserWithCompletion: { (isDownvoted) in
            cell.downvoteButton.isSelected = isDownvoted
            cell.downvoteButton.isUserInteractionEnabled = !isDownvoted
        })
        
        VoteService.isPostUpvoted(post, byCurrentUserWithCompletion: { (isUpvoted) in
            cell.upvoteButton.isSelected = isUpvoted
            cell.upvoteButton.isUserInteractionEnabled = !isUpvoted
        })
        
        if post.tags.count == 1 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.alpha = 0.0
            cell.thirdTag.alpha = 0.0
        } else if post.tags.count == 2 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.text = post.tags[1]
            cell.thirdTag.alpha = 0.0
        } else if post.tags.count == 3 {
            cell.firstTag.text = post.tags[0]
            cell.secondTag.text = post.tags[1]
            cell.thirdTag.text = post.tags[2]
        }

        
        cell.upvoteCountLabel.text = "\(post.upvoteCount)"
        cell.downvoteLabel.text = "\(post.downvoteCount)"
        tableView.reloadSections(IndexSet(integer: index), with: .bottom)
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
            VoteService.setIsUpvoted(!post.isUpvoted, isDownvoted: cell.downvoteButton.isSelected, for: post) { (success) in
    
                guard success else { return }
                
                DispatchQueue.main.async {
                    self.configureSingleCell(cell, with: post, index: indexPath.section)
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
            VoteService.setIsDownvoted(!post.isDownvoted, isUpvoted: cell.upvoteButton.isSelected, for: post) { (success) in
    
                guard success else { return }
             
                DispatchQueue.main.async {
                    self.configureSingleCell(cell, with: post, index: indexPath.section)
                }
            }
        }
    }
    
    func updateSingleCell(on cell: ExploreFeedFooterCell) {
        
    }
}



