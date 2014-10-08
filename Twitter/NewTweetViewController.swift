//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/8/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController,UINavigationBarDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var signOutBtn = UIButton()
        signOutBtn.bounds = CGRectMake(0, 0, 75, 10)
        signOutBtn.setTitle("Cancel", forState: UIControlState.Normal)
        signOutBtn.addTarget(self, action: "cancelTweet", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: signOutBtn)
        
        var newBtn = UIButton()
        newBtn.bounds = CGRectMake(0, 0, 75, 10)
        newBtn.setTitle("Tweet", forState: UIControlState.Normal)
        newBtn.addTarget(self, action: "sendTweet", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarItem = UIBarButtonItem(customView: newBtn)
        
        var navItem = UINavigationItem()
        navItem.leftBarButtonItem = leftBarItem
        navItem.rightBarButtonItem = rightBarItem
        navItem.title = ""
        navBar.items = [navItem]
        
        navBar.delegate = self
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
