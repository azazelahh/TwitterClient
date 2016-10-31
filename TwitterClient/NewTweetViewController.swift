//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 10/30/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    let characterLimit: Int = 140
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var tweetView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetView.delegate = self
        tweetView.becomeFirstResponder()
        
        let user = User.currentUser
        userImage.setImageWith((user?.profileUrl)!)
        name.text = user?.name
        username.text = "@" + (user?.screenName)!
        count.text = String(0)
        
    }
    @IBAction func onCancelButtonTap(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTweetButtonTap(_ sender: AnyObject) {
        
        let text = tweetView.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        TweeterClient.sharedInstance?.postTweet(text: text, success: {
            
        }, failure: { (error: Error) in
            print("tweet did not post. \(error)")
        })
        self.dismiss(animated: true, completion: nil)        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text!
        count.text = String(describing: text.characters.count)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars <= characterLimit;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
