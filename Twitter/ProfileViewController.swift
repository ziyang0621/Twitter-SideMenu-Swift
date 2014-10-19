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

let kHeaderHeight:CGFloat = 200
let kNavigatonBarPlusStatusBarHeight:CGFloat = 64

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var userName: String = ""
    
    var userInfo: User?
    
    var delegate: ProfileViewControllerDelegate?
    
    var tweets: [Tweet]?
    
    var fromMenu = true
    
    let formatter = NSDateFormatter()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    var effectView: UIVisualEffectView!
    
    var viewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromMenu {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "onClose")
        }
        
        self.navigationItem.title = "Profile"
        
        formatter.dateFormat = "MM/dd/yy"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
        
        var effect = UIBlurEffect(style: .Light)
        effectView = UIVisualEffectView(effect: effect)
        effectView.alpha = 0
        
        refreshProfile()
        refreshUserInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        effectView.frame = bannerImageView.frame
        bannerImageView.addSubview(effectView)
        viewDidAppear = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        viewDidAppear = false
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
        })
    }
    
    func refreshUserInfo() {
        var param = ["screen_name" : userName]
        TwitterClient.sharedInstance.userTimeLineWithCompletionWithParams(param, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if yPos > 0 && viewDidAppear {
            var imgRect = effectView.frame
            imgRect.origin.y = scrollView.contentOffset.y + kNavigatonBarPlusStatusBarHeight
            imgRect.size.height = kHeaderHeight+yPos
            effectView.frame = imgRect
            effectView.alpha = 1
        }
    }
    

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        UIView.beginAnimations("fade in", context: nil)
        UIView.setAnimationDuration(0.5)
        effectView.alpha = 0
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetCell
        
        var tweet = self.tweets?[indexPath.row]
        var user = tweet?.user
        cell.nameLabel.text = user?.name
        if let screenName = user?.screenname {
            cell.screenLabel.text = "@\(screenName)"
        } else {
            cell.screenLabel.text = ""
        }
        var date = tweet?.createdAt
        cell.timeLabel.text = formatter.stringFromDate(date!)
        cell.tweetTextLabel.text = tweet?.text
        if let profileImageUrl = tweet?.user?.profileImageUrl {
            cell.profileImageView.setImageWithURL(NSURL(string: profileImageUrl))
        }
        
        return cell
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
