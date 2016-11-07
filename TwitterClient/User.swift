//
//  User.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import Foundation

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    var backgroundUrl: URL?
    var tweetCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = URL(string: backgroundUrlString)
        }
        tweetCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
    }
    
    static var _currentUser: User?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {

                let defaults = UserDefaults.standard
                let userData = defaults.value(forKey: "currentUser") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }
    

}
