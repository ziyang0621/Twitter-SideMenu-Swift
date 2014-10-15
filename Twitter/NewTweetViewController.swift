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
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var statusTextView: UITextView!
    
    var delegate :NewTweetViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTweet")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "sendTweet")
        
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
