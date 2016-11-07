//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import Foundation

protocol TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, userImageTapped user: User)
}

class TweetCell: UITableViewCell {
    
    var delegate: TweetCellDelegate?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    var user: User!
    
    var tweet: Tweet! {
        didSet {
            userName.text = tweet.userName!
            userScreenName.text = "@" + tweet.userScreenName!
            userImage.setImageWith(tweet.userImageUrl!)
            tweetText.text = tweet.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            timestamp.text = dateFormatter.string(from: tweet.timestamp as! Date)
            if  tweet.retweeted != nil && tweet.retweeted! {
                retweetView.isHidden = false
                retweetedLabel.isHidden = false
            } else {
                retweetView.isHidden = true
                retweetedLabel.isHidden = true
            }
            self.user = tweet.user
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(tap(_:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tweetCell(tweetCell: self, userImageTapped: self.user)

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
