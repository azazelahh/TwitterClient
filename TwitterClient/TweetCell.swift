//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    var tweet: Tweet! {
        didSet {
            userName.text = tweet.userName!
            userScreenName.text = "@" + tweet.userScreenName!
            userImage.setImageWith(tweet.userImageUrl!)
            tweetText.text = tweet.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            timestamp.text = dateFormatter.string(from: tweet.timestamp as! Date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func replyButtonTap(_ sender: AnyObject) {
        TweeterClient.sharedInstance?.replyTweet(text: "reply", id: tweet.id, success: {
            
            }, failure: { (error: Error) in
                print("Did not reply to tweet. \(error.localizedDescription)")
        })
    }
    @IBAction func retweetButtonTap(_ sender: AnyObject) {

        TweeterClient.sharedInstance?.retweet(id: tweet.id, success: {
            
            }, failure: { (error: Error) in
                print("Did not retweet. \(error.localizedDescription)")
        })
    }
    @IBAction func favoriteButtonTap(_ sender: AnyObject) {

        TweeterClient.sharedInstance?.favoriteTweet(id: tweet.id, success: {
            
            }, failure: { (error: Error) in
                print("Did not favorite tweet. \(error.localizedDescription)")
        })
    }

}
