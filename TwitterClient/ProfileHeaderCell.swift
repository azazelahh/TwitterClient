//
//  ProfileHeaderCell.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 11/4/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUserProperties(user: User!) {
        if user != nil {
            backgroundImageView.setImageWith(user.backgroundUrl!)
            profileImageView.setImageWith(user.profileUrl!)
            nameLabel.text = user.name
            usernameLabel.text = user.screenName
            tweetCount.text = String(describing: user.tweetCount!)
            followingCount.text = String(describing: user.followingCount!)
            followerCount.text = String(describing: user.followerCount!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
