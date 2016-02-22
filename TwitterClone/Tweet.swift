//
//  Tweet.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/19/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favCount: Int = 0
    var user: NSDictionary
    var username: User
    var id: Int?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favourites_count"] as? Int) ?? 0
        user = (dictionary["user"] as? NSDictionary)!
        username = User(dictionary: user)
        id = dictionary["id"] as? Int
//        retweetCount = (dictionary["retweet_count"] as? Int)!
//        favCount = (dictionary["favourites_count"] as? Int)!
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStampString)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    

}
