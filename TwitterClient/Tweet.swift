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
    var retweeted: Bool?
    var mediaUrl: URL?
    var user: User!
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        let userDictionary = dictionary["user"] as! NSDictionary
        userScreenName = userDictionary["screen_name"] as? String
        let urlString = userDictionary["profile_image_url_https"] as? String
        userImageUrl = URL(string: urlString!)!
        userName = userDictionary["name"] as? String
        
        retweetCount = (dictionary["retweet_count"] as! Int) 
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        if let entitiesDictionary = dictionary["entities"] as? NSDictionary {
            if let mediaDictionary = (entitiesDictionary["media"] as? NSArray)?[0] as? NSDictionary {
                if let mediaUrl = mediaDictionary["media_url_https"] as? String {
                    self.mediaUrl = URL(string: mediaUrl)!
                }
            }
        }
        
        self.user = User(dictionary: userDictionary)
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
