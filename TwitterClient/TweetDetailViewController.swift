//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/30/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var retweets: UILabel!
    @IBOutlet weak var favorites: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaImageViewHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.setImageWith(tweet.userImageUrl!)
        name.text = tweet.userName
        username.text = "@" + tweet.userScreenName!
        text.text = tweet.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, H:mm a"
        timestamp.text = dateFormatter.string(from: tweet.timestamp as! Date)
        retweets.text = String(tweet.retweetCount)
        favorites.text = String(tweet.favoriteCount)
        
        if tweet.mediaUrl == nil {
            mediaImageView.isHidden = true
            mediaImageViewHeightConstraint.constant = 0
        } else {
            mediaImageView.isHidden = false
            mediaImageViewHeightConstraint.constant = 200
            mediaImageView.setImageWith(tweet.mediaUrl!)
        }
        
        self.userImage.layer.cornerRadius = 5
        self.userImage.clipsToBounds = true
        
    }
    
    @IBAction func onReplyButtonTap(_ sender: AnyObject) {
        
        TweeterClient.sharedInstance?.replyTweet(text: "reply", id: tweet.id, success: { 
            self.replyButton.setImage(#imageLiteral(resourceName: "replied"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("Did not reply to tweet. \(error.localizedDescription)")
        })
    }
    
    @IBAction func onRetweetButtonTap(_ sender: AnyObject) {
        
        self.retweets.text = String(self.tweet.retweetCount + 1)
        TweeterClient.sharedInstance?.retweet(id: tweet.id, success: { 
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweeted"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("Did not retweet. \(error.localizedDescription)")
        })
    }
    
    @IBAction func onFavoriteButtonTap(_ sender: AnyObject) {
        
        self.favorites.text = String(self.tweet.favoriteCount + 1)
        TweeterClient.sharedInstance?.favoriteTweet(id: tweet.id, success: { 
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorited"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("Did not favorite tweet. \(error.localizedDescription)")
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
