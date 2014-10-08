//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/6/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let twitterConsumerKey = "QJxHwChx3tnwMeIrO9WdyuQWn"
let twitterConsumerSecret = "mYhpVksXy80vPihwvncMWTY8FavyAohqA5O8YlSZflwmWXBH9i"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        return Static.instance
    }
    
    func homeTimeLineWithCompletionWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
             println("home line: \(response[0])")
            
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
////            for tweet in tweets {
////                println("text: \(tweet.text), created: \(tweet.createdAt)")
////            }
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func composeCompletionWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("new tweet: \(response)")
        
                completion(tweets: nil, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error composing new tweet")
                completion(tweets: nil, error: error)
        })
    }

    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {(requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) {(error: NSError!) -> Void in
                println("Failed to request token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func openURL(url: NSURL) {
        
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: {(accessToken: BDBOAuthToken!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //                    println("user: \(response)")
                
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
        }) {(error: NSError!) -> Void in
            println("Fail to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
        
    }
}
