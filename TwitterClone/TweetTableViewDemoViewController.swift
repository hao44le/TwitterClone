//
//  1.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

// Swift
import TwitterKit

class TweetTableViewDemoViewController: UITableViewController, TWTRTweetViewDelegate,TWTRComposerViewControllerDelegate {
    let tweetTableReuseIdentifier = "TweetCell"
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = []
    var isHeaderRefresh = false
    var max_id : String? = "1"
    var selectedTweet : TWTRTweet!
    var selectedUser: User!
    
    override func viewDidLoad() {
        // Setup the table view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidSwitchAccount", name: "userDidSwitchAccount", object: nil)
        TWTRTweetView.appearance().theme = TWTRTweetViewTheme.Light
//        self.navigationItem.title = "Home"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tableView.allowsSelection = false
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        // Load Tweets
        setupTableRefresh()
        
        refreshData(nil)
        
        addButtons()
        
    }
    func userDidSwitchAccount(){
        refreshData(nil)
    }
    
    
    func addButtons(){
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutpressed")
        self.navigationItem.leftBarButtonItem = logoutButton
        
        let newButton = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.Plain, target: self, action: "newPressed")
        self.navigationItem.rightBarButtonItem = newButton
    }
    func newPressed(){
//        let composer = TWTRComposer()
//        // Called from a UIViewController
//        composer.showFromViewController(self) { result in
//            if (result == TWTRComposerResult.Cancelled) {
//                print("Tweet composition cancelled")
//            }
//            else {
//                self.refreshData(nil)
//            }
//        }
        // Users must be logged-in to compose Tweets
        if let session = Twitter.sharedInstance().sessionStore.session() {
            
            let composer = TWTRComposerViewController(userID: session.userID, cardConfiguration: nil)
            
            // Optionally set yourself as the delegate
            composer.delegate = self
            
            // Show the view controller
            presentViewController(composer, animated: true, completion: nil)
        }
    }
    
    
    func composerDidSucceed(controller: TWTRComposerViewController, withTweet tweet: TWTRTweet) {
        self.refreshData(nil)
    }
    
    func logoutpressed(){
        
        TwitterClient.sharedInstance.deauthorize()
        if var array = NSUserDefaults.standardUserDefaults().objectForKey("userArray") as? [NSData] {
            
                array.removeLast()
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "userArray")
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getUserTimeline(){
        
        
        
    }
    
    func setupTableRefresh(){
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.isHeaderRefresh = true
            self.refreshData(nil)
        })
        header.setTitle("Pull down to refresh", forState: MJRefreshState.Idle)
        header.setTitle("Release to refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Loading ...", forState: MJRefreshState.Refreshing)
        header.stateLabel?.textColor = UIColor.blackColor()
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            self.refreshData(self.max_id)
        })
    }
    
    func refreshData(max_id:String?){
        Tool.showProgressHUD("Loading Tweets")
        TwitterClient.sharedInstance.getUserTimeLine(max_id) { (var tweets_array:[TWTRTweet]?, error) -> Void in
            Tool.dismissHUD()
            if self.tableView.mj_header.isRefreshing(){
                
                self.tableView.mj_header.endRefreshing()
            }
            if self.tableView.mj_footer.isRefreshing(){
                
                self.tableView.mj_footer.endRefreshing()
            }
            if self.isHeaderRefresh{
                self.isHeaderRefresh = false
            }
            if max_id == nil && tweets_array != nil{
                self.tweets = tweets_array!
                self.max_id = (tweets_array!.last?.tweetID)!
            } else {
                if tweets_array?.count != 0 {
                    tweets_array!.removeFirst()
                    self.max_id = (tweets_array!.last?.tweetID)!
                }
                
                for item in tweets_array! {
                    self.tweets.append(item)
                }
                
                
            }
            self.tableView.reloadData()
        }
        
    }

    
    // MARK: UITableViewDelegate Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        cell.tweetView.showActionButtons = true
        cell.tweetView.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds), showingActions: true)
    }
    func tweetView(tweetView: TWTRTweetView, didTapProfileImageForUser user: TWTRUser) {
        print("didTapProfileImageForUser")
        Tool.showProgressHUD("Loading user profile")
        TwitterClient.sharedInstance.getUserDetail(user.screenName) { (user, error) -> Void in
            if user != nil {
                self.selectedUser = user
                Tool.dismissHUD()
                self.performSegueWithIdentifier("toUser", sender: self)
            }
            if error != nil {
                Tool.dismissHUD()
                Tool.showErrorHUD("An Error Occuered")
            }
        }
        
    }
    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        print("didSelectTweet")
        self.selectedTweet = tweet
        self.performSegueWithIdentifier("toDetail", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            let desVC = segue.destinationViewController as! DetailViewController
            desVC.selectedTweet = self.selectedTweet
        } else if segue.identifier == "toUser" {
            let desVC = segue.destinationViewController as! UserViewController
            desVC.source = "UserTimelineViewController"
            desVC.user = self.selectedUser
        }
    }
}
