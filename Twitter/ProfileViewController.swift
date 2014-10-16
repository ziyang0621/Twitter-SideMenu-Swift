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
    
    var delegate: ProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
        self.navigationItem.title = "Profile"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
