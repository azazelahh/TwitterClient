//
//  Tweet.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: String?
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var userScreenName: String?
    var userImageUrl: URL?
    var userName: String?
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        let user = dictionary["user"] as! NSDictionary
        userScreenName = user["screen_name"] as? String
        let urlString = user["profile_image_url_https"] as? String
        userImageUrl = URL(string: urlString!)!
        userName = user["name"] as? String
        
        retweetCount = (dictionary["retweet_count"] as! Int) 
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) ->[Tweet] {
    
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
