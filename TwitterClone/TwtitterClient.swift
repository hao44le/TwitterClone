//
//  TwtitterClient.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit

let key = "4pPb2nGQyXXUfMRoXwr7IsDAg"
let secret = "eMmGmMYhOMxZ0IFCCDFi4bqFfLybeQJTjLFrjgqCZX4zd8624C"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion : ((user: User?,error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: key, consumerSecret: secret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?,error: NSError?) -> Void ){
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (token:BDBOAuth1Credential!) -> Void in
            print("sucess get the token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                print(error)
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func openURL(url:NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (credential:BDBOAuth1Credential!) -> Void in
            print("Got access token\(credential.token)")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(credential)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
                    print("successfully get the user")
                    let user = User.mj_objectWithKeyValues(response)
                    self.loginCompletion?(user:user, error: nil)
                }, failure: { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                    print("failed to get current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            }) { (error:NSError!) -> Void in
                print("failed to get access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func getUserTimeLine(completion: (tweets: [Tweet]?,error: NSError?) -> Void){
//        let para = ["since_id":"694628730933739520"]
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
                print("successfully get user timeline")
            var tweets : [Tweet] = []
            let array = response as! NSArray
            for item in array {
                let tweet = Tweet.mj_objectWithKeyValues(item)
                tweets.append(tweet)
            }
            completion(tweets: tweets, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print("failed to get user timeline")
                completion(tweets: nil, error: error)
        }
    }
    
}
