//
//  MentionViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/16/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

@objc
protocol MentionViewControllerDelegate {
    optional func toggleLeftPanel()
}

class MentionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    
    var delegate: MentionViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
        self.navigationItem.title = "Mention"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 125.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
        
        formatter.dateFormat = "MM/dd/yy"

        refreshControl.addTarget(self, action: "refreshMentions", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        refreshMentions()
    }
    
    func refreshMentions() {
        TwitterClient.sharedInstance.mentionTimeLineWithCompletionWithParams(nil, completion: { (tweets, error) -> () in
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
    
    func onMenu() {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
