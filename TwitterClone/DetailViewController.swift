//
//  DetailViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 10/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit

class DetailViewController: UIViewController,UITextFieldDelegate {

    var selectedTweet : TWTRTweet!
    var textFiled: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureUI()
        // Do any additional setup after loading the view.
    }
    
    func congifureUI(){
        let tweetView = TWTRTweetView(tweet: self.selectedTweet)
        tweetView.showActionButtons = true
        tweetView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2)
        self.view.addSubview(tweetView)
        
        textFiled = UITextField(frame: CGRectMake(0,UIScreen.mainScreen().bounds.height - 100,UIScreen.mainScreen().bounds.width - 50 ,50))
        textFiled.borderStyle = UITextBorderStyle.RoundedRect
        textFiled.delegate = self
        textFiled.placeholder = "Reply to \(self.selectedTweet.author.screenName)"
        self.view.addSubview(textFiled)
        
        let replyButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 50,UIScreen.mainScreen().bounds.height - 100,50,50))
        replyButton.setTitle("Reply", forState: UIControlState.Normal)
        replyButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        replyButton.addTarget(self, action: "replyButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(replyButton)
        
        
        
        
    }
    
    func replyButtonClicked(){
        //print(self.textFiled.text)
        if self.textFiled.text == nil || self.textFiled.text == "" {
            Tool.showErrorHUD("Please type your text")
        } else {
            let text = "@\(self.selectedTweet.author.screenName) \(self.textFiled.text!)"
            TwitterClient.sharedInstance.repliesToATweet(text, id: self.selectedTweet.tweetID, completion: { (success) -> Void in
                if success {
                    Tool.showSuccessHUD("Replies succeed!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    Tool.showErrorHUD("Replies failed.Please try again.")
                }
            })

        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
