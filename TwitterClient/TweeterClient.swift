//
//  TweeterClient.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TweeterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TweeterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "pi3d6aswqwcv17ynvjkbpoMLH", consumerSecret: "SBbdkZVuJEFY3jI1Xmpe87W4OaSx3Hjo1DH7z10ZzmEnv9HPd8")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TweeterClient.sharedInstance?.deauthorize()
        
        TweeterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            
            print("I got a token")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }) { (error: Error?) -> Void in
            
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("I got access token!")
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: Error) -> () in
                    self.loginFailure?(error)
            })

        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let tweetDictionaries = response as! [NSDictionary]
            print(tweetDictionaries[0])
            
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func postTweet(text: String!, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let postText = "1.1/statuses/update.json?status=\(text!)"
        post(postText, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            print("Your tweet is posted")
            success()
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func replyTweet(text: String!, id: String!, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        post("1.1/statuses/update.json?status=\(text!)&in_reply_to_status_id=\(id!)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            print("Replied to tweet")
            success()
            }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func retweet(id: String!, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        post("1.1/statuses/retweet/\(id!).json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            print("Retweeted tweet")
            success()
            }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func favoriteTweet(id: String!, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        post("1.1/favorites/create.json?id=\(id!)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            print("Favorited tweet")
            success()
            }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }

}
