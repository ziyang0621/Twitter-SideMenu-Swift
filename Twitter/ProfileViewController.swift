//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/15/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

@objc
protocol ProfileViewControllerDelegate {
    optional func toggleLeftPanel()
}

class ProfileViewController: UIViewController {
    
    var userName: String = ""
    
    var userInfo: User?
    
    var delegate: ProfileViewControllerDelegate?
    
    var refreshControl = UIRefreshControl()
    
    var fromMenu = true

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fromMenu {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "onClose")
        }
        
        self.navigationItem.title = "Profile"
                
        refreshControl.addTarget(self, action: "refreshProfile", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        refreshProfile()
    }
 
    func refreshProfile() {
        var param = ["screen_name" : userName]
        TwitterClient.sharedInstance.showUserCompletionWithParams(param, completion: { (user, error) -> () in
            
            self.nameLabel.text = user?.name
            if let screenName = user?.screenname {
                self.screenNameLabel.text = "@\(screenName)"
            }
            if let profileImageUrl = user?.profileImageUrl {
                self.profileImageView.setImageWithURL(NSURL(string: profileImageUrl))
            }
            if let bannerImageUrl = user?.profileBannerUrl {
                self.bannerImageView.setImageWithURL(NSURL(string: bannerImageUrl))
            }
            if let tweetCount = user?.statusesCount {
                self.tweetCountLabel.text = "\(tweetCount)"
            }
            if let followingCount = user?.followingCount {
                self.followingCountLabel.text = "\(followingCount)"
            }
            if let followerCount = user?.followerCount {
                self.followerCountLabel.text = "\(followerCount)"
            }
            
            self.refreshControl.endRefreshing()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onMenu() {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }
    
    func onClose() {
       dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
