//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/6/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kNewTweetSegue = "newTweetSegue"

@objc
protocol TweetsViewControllerDelegate {
    optional func toggleLeftPanel()
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate {

    var tweets: [Tweet]?
    
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var delegate: TweetsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onLogout")
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

    
    func sentNewTweet(controller: NewTweetViewController) {
        refreshTweets()
    }
    
    func newTweet() {
        performSegueWithIdentifier(kNewTweetSegue, sender: self)
    }
    
    func onLogout() {
       // User.currentUser?.logout()
        if let d = delegate {
            d.toggleLeftPanel?()
        }
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
