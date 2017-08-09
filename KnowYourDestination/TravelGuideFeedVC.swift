//
//  TravelGuideFeedVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/16/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase

class TravelGuideFeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cityPosts = [CityPost]()
    let refreshControl = UIRefreshControl()
    var cityPostText: String = ""
    let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
    
    let paginationHelper = MGPaginationHelper<CityPost>(serviceMethod: CityPostService.cityPosts)
    
    lazy var cityPostImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
        configureTableView()
        reloadTimeline()

//        CityPostService.cityPosts(pageSize: <#UInt#>, lastPostKey: <#String?#>) { (posts) in
//            self.cityPosts = posts.reversed()
//            self.tableView.reloadData()
//        }
    }
    
    
    func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func reloadTimeline(){
        self.paginationHelper.reloadData { [unowned self] (posts) in
            self.cityPosts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
        
//        CityPostService.cityPosts(pageSize: 4, lastPostKey: cityPosts) { (posts) in
//            self.cityPosts = posts.reversed()
//            self.tableView.reloadData()
//        }
    }
    
    func handleFlagButtonTap(from cell: ExploreFeedHeaderCell) {
        // 1
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 2
        let post = cityPosts[indexPath.section]
        let poster = post.postById
        
        // 3
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // 4
        if poster != Auth.auth().currentUser?.uid {
            let flagAction = UIAlertAction(title: "Report as Inappropriate", style: .default) { _ in
                CityPostService.flag(post)
                
                let okAlert = UIAlertController(title: nil, message: "The post has been flagged.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
            }
            
            alertController.addAction(flagAction)
            
            // 5
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // 6
            present(alertController, animated: true, completion: nil)
        } else {
            
            let flagAction = UIAlertAction(title: "You can only report content added by other users", style: .default)
            
            alert.addAction(flagAction)
            
        }
        
        
    }
}


extension TravelGuideFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = cityPosts[indexPath.section]
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedHeaderCell", for: indexPath) as! ExploreFeedHeaderCell
            cell.didTapFlagButtonForCell = handleFlagButtonTap(from:)
            
            return cell
            
            
        case 1:
            
            if let _ = URL(string: post.imageUrl){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedImageCell", for: indexPath) as! ExploreFeedImageCell
                
                cell.postTextLabel.text = post.text
                cell.postImage.image = post.image!
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedTextCell", for: indexPath) as! ExploreFeedTextCell
                cell.postTextLabel.text = post.text
                return cell
            }
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedFooterCell", for: indexPath) as! ExploreFeedFooterCell
            cell.delegate = self
            
            cell.downvoteButton.isSelected = false
            cell.upvoteButton.isSelected = false
            
            configureCell(cell, with: post, index: indexPath.section)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    
    func configureCell(_ cell: ExploreFeedFooterCell, with post: CityPost, index: Int) {
        
        cell.postedByLabel.text = "By: \(post.postByName)"
        cell.upvoteCountLabel.text = "\(post.upvoteCount)"
        cell.downvoteLabel.text = "\(post.downvoteCount)"
        
        cell.downvoteButton.isSelected = post.isDownvoted
        cell.downvoteButton.isUserInteractionEnabled = !post.isDownvoted

        cell.upvoteButton.isSelected = post.isUpvoted
        cell.upvoteButton.isUserInteractionEnabled = !post.isUpvoted
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityPosts.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section >= cityPosts.count - 2 {
            paginationHelper.paginate(completion: { [unowned self] (posts) in
                self.cityPosts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
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
                    post.isUpvoted = true
                    post.isDownvoted = false
                    self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
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
                    post.isDownvoted = true
                    post.isUpvoted = false

                    self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
                }
            }
        }
    }
    
    func updateSingleCell(on cell: ExploreFeedFooterCell) {
        
    }
}



