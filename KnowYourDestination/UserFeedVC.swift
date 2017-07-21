//
//  UserFeedVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/16/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserFeedVC: UIViewController {
    
    var cityPosts = [CityPost](){
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var cityPostImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "downvote")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
        
        ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            
            let posts: [CityPost] = snapshot.reversed().flatMap{
                guard let post = CityPost(snapshot: $0)
                    else {return nil}
                
                if let imageURL = URL(string: post.imageUrl) {
                    
                    URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                        
                        guard let imgData = data
                            else {return}
                        
                        DispatchQueue.main.async {
                            post.image = UIImage(data: imgData)
                        }
                    }).resume()
                }
                
                return post
            }
            
            self.cityPosts = posts
            
        })

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


extension UserFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = cityPosts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            
            if let _ = URL(string: post.imageUrl){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedImageCell", for: indexPath) as! ExploreFeedImageCell
                
                cell.postTextLabel.text = post.text
                cell.postImage.image = post.image
                print("Image cell")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedTextCell", for: indexPath) as! ExploreFeedTextCell
                cell.postTextLabel.text = post.text
                print("text cell")
                return cell
            }
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFeedFooterCell", for: indexPath) as! ExploreFeedFooterCell
            //            cell.delegate = self
            //            configureCell(cell, with: post)
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityPosts.count
    }
    
}
