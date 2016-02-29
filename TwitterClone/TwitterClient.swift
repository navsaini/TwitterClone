//
//  TwitterClient.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/15/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "XTfZPTmDKe6iNPn3l287SlrPp"
let twitterConsumerSecret = "rnqRRawpjNR6qTngl79jN5LyfBZFGPqGVuIamG2fjhoRAtVM9K"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var sharedInstance: TwitterClient {
        struct StaticProp {
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return StaticProp.instance
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            print("Failed to get request token")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got the access token")
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure!(error)
            })
            
           
            
        }) { (error: NSError!) -> Void in
            print("failed to receive access token")
            self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error, could not get tweets")
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            
            print(user.name)
        }, failure: { (task: NSURLSessionDataTask?,error: NSError) -> Void in
                failure(error)
                print("error, could not get user info")
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
    func retweetWithID(id: Int, completion : (tweet : Tweet?, error: NSError?) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            
            var array : [NSDictionary] = [NSDictionary]()
            array.append(response as! NSDictionary)
            let tweets = Tweet.tweetsWithArray(array)
            completion(tweet: tweets[0], error: nil)
            
            }) { (response: NSURLSessionDataTask?, error: NSError) -> Void in
                print("there was an error")
                completion(tweet: nil, error: error)
        }
    }
    
    func favWithID(id: Int, completion : (tweet : Tweet?, error: NSError?) -> ()){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            var array : [NSDictionary] = [NSDictionary]()
            array.append(response as! NSDictionary)
            let tweets = Tweet.tweetsWithArray(array)
            completion(tweet: tweets[0], error: nil)
            }) {
                (response: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    

}
