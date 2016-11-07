//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/29/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    var delegate: TweetCellDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getHomeTimeline()

    }

    @IBAction func onLogoutButtonTap(_ sender: AnyObject) {
        TweeterClient.sharedInstance?.logout()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets != nil){
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func getHomeTimeline() {
        
        TweeterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getHomeTimeline()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let cell = sender as! UITableViewCell
            let indexPath =  tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as! TweetDetailViewController
            detailViewController.tweet = tweet
        } else if (segue.identifier == "ProfileSegue") {
            let profileNavigationController = segue.destination as! UINavigationController
            (profileNavigationController.viewControllers[0] as! ProfileViewController).user = self.user
        }
    }
    
    func tweetCell(tweetCell: TweetCell, userImageTapped user: User) {
        self.user = user
        self.performSegue(withIdentifier: "ProfileSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
