//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 11/3/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var tweetsViewController: TweetsViewController!
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var user: User! {
        didSet {
            getUserTimeline()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        if self.user == nil {
            setUser()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets != nil){
            return tweets.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            
            (cell as! ProfileHeaderCell).setUserProperties(user: self.user)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            (cell as! TweetCell).tweet = tweets[indexPath.row - 1]
        }
        
        return cell
    }
    
    func setUser() {
        TweeterClient.sharedInstance?.currentAccount(success: { (user: User) in
            self.user = user
            print(user)
            self.tableView.reloadData()
            
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    func getUserTimeline() {
        TweeterClient.sharedInstance?.userTimeline(username: self.user.screenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            self.tableView.reloadData()
            
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    @IBAction func onCancelButtonTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
