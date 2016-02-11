//
//  UserViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 10/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit
class UserViewController: UIViewController,UIScrollViewDelegate,TWTRTweetViewDelegate,UITableViewDataSource {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tableView:UITableView!
    let tweetTableReuseIdentifier = "TweetCell"
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = []
    var isHeaderRefresh = false
    
    
    var source = ""
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        if source == "UserTimelineViewController" {
            configureUI()

        } else {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("userObject") as? NSData {
                
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                unarc.setClass(User.self, forClassName: "User")
                user = unarc.decodeObjectForKey("root") as! User
                configureUI()

            }
            
        }
        addLongPress()
        // Do any additional setup after loading the view.
    }
    func configureUI(){
        
        scrollView.delegate = self
//            print(user)
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
//            scrollView.setContentOffset(CGPoint(x: 0, y: -200), animated: true)
            let customView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200))
            customView.contentMode = UIViewContentMode.ScaleAspectFill
            customView.sd_setImageWithURL(NSURL(string: user.profile_background_image_url!) , placeholderImage: UIImage(named: "placeholder.jpg"))
            scrollView.addParallaxWithView(customView, andHeight: 200, andShadow: true)
            
            let userIconImageView = UIImageView(frame: CGRectMake(15,-20,80,80))
            userIconImageView.sd_setImageWithURL(NSURL(string: user.profile_image_url_https!), placeholderImage: UIImage(named: "placeholder.jpg"))
            userIconImageView.layer.borderColor = UIColor.whiteColor().CGColor
            userIconImageView.layer.borderWidth = 4
            scrollView.addSubview(userIconImageView)
            
            let userName = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 220,0,200,30))
            userName.textAlignment = NSTextAlignment.Right
            userName.text = user.name
            userName.font = UIFont.boldSystemFontOfSize(20)
            scrollView.addSubview(userName)
            
            let userscreenName = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 220,40,200,30))
            userscreenName.textAlignment = NSTextAlignment.Right
            userscreenName.text = "@\(user.screen_name!)"
            userscreenName.textColor = UIColor.grayColor()
            userscreenName.font = UIFont.systemFontOfSize(18)
            scrollView.addSubview(userscreenName)

            let description = UILabel(frame: CGRectMake(15,85,UIScreen.mainScreen().bounds.width - 30,50))
            description.text = user.descriptionOfSelf
            description.font = UIFont.systemFontOfSize(19)
            description.numberOfLines = 0
            scrollView.addSubview(description)
            
            let locationLabel = UILabel(frame: CGRectMake(15,145,UIScreen.mainScreen().bounds.width - 30,30))
            locationLabel.text = "Location: \(user.location!)"
            locationLabel.textAlignment = NSTextAlignment.Center
            locationLabel.textColor = UIColor.grayColor()
            scrollView.addSubview(locationLabel)
            
            let labelWidth = (UIScreen.mainScreen().bounds.width - 40) / 2
            
            let followersLabel = UILabel(frame: CGRectMake(15,185,labelWidth,30))
            followersLabel.text = "\(user.followers_count!) FOLLOWERS"
            followersLabel.font = UIFont.systemFontOfSize(15)
            followersLabel.textColor = UIColor.grayColor()
            followersLabel.textAlignment = NSTextAlignment.Center
            scrollView.addSubview(followersLabel)
            
            let followingLabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 25 - labelWidth,185,labelWidth,30))
            followingLabel.text = "\(user.friends_count!) FOLLWING"
            followingLabel.font = UIFont.systemFontOfSize(15)
            followingLabel.textAlignment = NSTextAlignment.Center
            followingLabel.textColor = UIColor.grayColor()
            scrollView.addSubview(followingLabel)
            
        let tweetsLabel = UILabel(frame: CGRectMake(15,225,UIScreen.mainScreen().bounds.width - 30,30))
        tweetsLabel.text = "#tweets: \(user.statuses_count!)"
        tweetsLabel.textAlignment = NSTextAlignment.Center
        tweetsLabel.textColor = UIColor.grayColor()
        scrollView.addSubview(tweetsLabel)
        
        
        self.tableView = UITableView(frame: CGRectMake(0,265,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height))
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tableView.allowsSelection = false
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
//        tableView.delegate = self
        tableView.dataSource = self
        // Load Tweets
        refreshData(nil)
        scrollView.addSubview(tableView)
        
    }

    func addLongPress(){
        let press = UILongPressGestureRecognizer(target: self, action: "longpressed")
        self.tabBarController?.tabBar.addGestureRecognizer(press)
    }
    func longpressed(){
        self.performSegueWithIdentifier("toSetting", sender: self)
    }
    
    func refreshData(max_id:String?){
        Tool.showProgressHUD("Loading Tweets")
        TwitterClient.sharedInstance.userTimelineWithParams(max_id,userID:self.user.screen_name!) { (tweets_array:[TWTRTweet]?, error) -> Void in
            Tool.dismissHUD()
            
            if tweets_array != nil{
                self.tweets = tweets_array!
                
            } else {
                
                for item in tweets_array! {
                    self.tweets.append(item)
                }
                
                
            }
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        cell.tweetView.showActionButtons = true
        cell.tweetView.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds), showingActions: true)
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
