//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/6/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var signOutBtn = UIButton()
        signOutBtn.bounds = CGRectMake(0, 0, 75, 20)
        signOutBtn.setTitle("Sign Out", forState: UIControlState.Normal)
        signOutBtn.addTarget(self, action: "onLogout", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: signOutBtn)
        
        var newBtn = UIButton()
        newBtn.bounds = CGRectMake(0, 0, 75, 20)
        newBtn.setTitle("New", forState: UIControlState.Normal)
      //  newBtn.addTarget(self, action: "applyFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarItem = UIBarButtonItem(customView: newBtn)
        
        var navItem = UINavigationItem()
        navItem.leftBarButtonItem = leftBarItem
        navItem.rightBarButtonItem = rightBarItem
        navItem.title = "Home"
        navBar.items = [navItem]
        
        navBar.delegate = self
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
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    

    func onLogout() {
        User.currentUser?.logout()
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
