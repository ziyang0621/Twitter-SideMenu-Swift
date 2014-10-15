//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/6/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kNewTweetSegue = "newTweetSegue"

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate {

    var tweets: [Tweet]?
    
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var cancelBtn = UIButton()
//        cancelBtn.frame = CGRectMake(0, 0, 75, 10)
//        cancelBtn.setTitle("Sign Out", forState: UIControlState.Normal)
//        cancelBtn.addTarget(self, action: "onLogout", forControlEvents: UIControlEvents.TouchUpInside)
//        var leftBarItem = UIBarButtonItem(customView: cancelBtn)
//        
//        var sendBtn = UIButton()
//        sendBtn.frame = CGRectMake(0, 0, 75, 10)
//        sendBtn.setTitle("New", forState: UIControlState.Normal)
//        sendBtn.addTarget(self, action: "newTweet", forControlEvents: UIControlEvents.TouchUpInside)
//        var rightBarItem = UIBarButtonItem(customView: sendBtn)
//        
//        var navItem = UINavigationItem()
//        navItem.leftBarButtonItem = leftBarItem
//        navItem.rightBarButtonItem = rightBarItem
//        navItem.title = "Home"
//        navBar.items = [navItem]
//        
//        navBar.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItemStyle.Plain, target: self, action: "onLogout")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.Plain, target: self, action: "newTweet")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 125.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        formatter.dateFormat = "MM/dd/yy"
        
        refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        refreshTweets()
    }
    
    func refreshTweets() {
        TwitterClient.sharedInstance.homeTimeLineWithCompletionWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            println(self.tweets?.count)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
//        return UIBarPosition.TopAttached
//    }
    
    func sentNewTweet(controller: NewTweetViewController) {
        refreshTweets()
    }
    
    func newTweet() {
        performSegueWithIdentifier(kNewTweetSegue, sender: self)
    }
    
    func onLogout() {
        User.currentUser?.logout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == kNewTweetSegue) {
            let detailVC = segue.destinationViewController as UINavigationController
            var newTweetVC = detailVC.viewControllers[0] as NewTweetViewController
            newTweetVC.delegate = self
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets?.count {
            return count
        } else {
            return 0
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
