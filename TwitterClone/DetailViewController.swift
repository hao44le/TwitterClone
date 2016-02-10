//
//  DetailViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 10/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit

class DetailViewController: UIViewController {

    var selectedTweet : TWTRTweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureUI()
        // Do any additional setup after loading the view.
    }
    
    func congifureUI(){
        let tweetView = TWTRTweetView(tweet: self.selectedTweet)
        tweetView.showActionButtons = true
        tweetView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        self.view.addSubview(tweetView)
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
