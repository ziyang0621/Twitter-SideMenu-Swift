//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/8/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

protocol NewTweetViewControllerDelegate {
    func sentNewTweet(controller:NewTweetViewController)
}

class NewTweetViewController: UIViewController,UINavigationBarDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var statusTextView: UITextView!
    
    var delegate :NewTweetViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var signOutBtn = UIButton()
        signOutBtn.frame = CGRectMake(0, 0, 75, 10)
        signOutBtn.setTitle("Cancel", forState: UIControlState.Normal)
        signOutBtn.addTarget(self, action: "cancelTweet", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: signOutBtn)
        
        var newBtn = UIButton()
        newBtn.frame = CGRectMake(0, 0, 75, 10)
        newBtn.setTitle("Tweet", forState: UIControlState.Normal)
        newBtn.addTarget(self, action: "sendTweet", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarItem = UIBarButtonItem(customView: newBtn)
        
        var navItem = UINavigationItem()
        navItem.leftBarButtonItem = leftBarItem
        navItem.rightBarButtonItem = rightBarItem
        navItem.title = ""
        navBar.items = [navItem]
        
        navBar.delegate = self
        
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = User.currentUser?.screenname
        if let imageURL = User.currentUser?.profileImageUrl {
            profileImageView.setImageWithURL(NSURL(string: imageURL))
        }
        
        statusTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func cancelTweet() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendTweet() {
        var param = ["status" : statusTextView.text]
        TwitterClient.sharedInstance.composeCompletionWithParams(param, completion: { (tweets, error) -> () in
            if error != nil {
                println(error)
            }
            else {
                println("success")
                self.delegate.sentNewTweet(self)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
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
