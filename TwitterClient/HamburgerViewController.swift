//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 11/3/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            self.view.layoutIfNeeded()
            if(oldContentViewController != nil) {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        contentViewController = tweetsNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Tweets", "Profile", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        contentViewController = viewControllers[indexPath.row]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
