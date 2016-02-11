//
//  TwtitterClient.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit

let keyA = "4pPb2nGQyXXUfMRoXwr7IsDAg"
let secretA = "eMmGmMYhOMxZ0IFCCDFi4bqFfLybeQJTjLFrjgqCZX4zd8624C"
let keyB = "fdUSd7SVqX7QkOyYRtIAd6LZk"
let secretB = "hHhS2R80nKDobRwr09RgrBkeDDWDGZ7XcuvtlhzXMB74Y48lZT"

let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion : ((user: User?,error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: keyA, consumerSecret: secretA)
            
        }
        return Static.instance
    }
    
    func checkUserLogin()->Bool{
        return TwitterClient.sharedInstance.requestSerializer.accessToken == nil
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
            print("Got access token\(credential.userInfo)")
            let id = credential.userInfo["user_id"] as! String
            NSUserDefaults.standardUserDefaults().setValue(id, forKey: "userID")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(credential)
            Twitter.sharedInstance().sessionStore.saveSessionWithAuthToken(credential.token, authTokenSecret: credential.secret, completion: { (session:TWTRAuthSession?, error:NSError?) -> Void in
                print("save to session store")
                print("error:\(error)")
                
            })
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
                    print("successfully get the user")
                    let description = response!["description"] as! String
                    let user = User.mj_objectWithKeyValues(response)
                    user.descriptionOfSelf = description
                    print(user)
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                    print("failed to get current user")
                    self.loginCompletion?(user: nil, error: error)
            })
//            let user = User()
//            self.loginCompletion?(user: user, error: nil)
            }) { (error:NSError!) -> Void in
                print("failed to get access token\(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func getUserTimeLine(max_id:String?,completion: (tweets: [TWTRTweet]?,error: NSError?) -> Void){
        var para : [String:AnyObject]!
        if max_id != nil {
            para = ["max_id":max_id!]
        } else {
            para = nil
        }
        
        GET("1.1/statuses/home_timeline.json", parameters: para, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
                print("successfully get user timeline")
            
            let array = response as! [AnyObject]
            let tweets : [TWTRTweet] = TWTRTweet.tweetsWithJSONArray(array) as! [TWTRTweet]
            
            completion(tweets: tweets, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print("failed to get user timeline : \(error)")
                completion(tweets: nil, error: error)
        }
    }
    
    func repliesToATweet(content:String,id:String,completion:(success:Bool)->Void){
        let para = ["status":content,"in_reply_to_status_id":id]
        print(id)
        POST("1.1/statuses/update.json", parameters: para, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("replies succeed")
            completion(success: true)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print("replies failed\(error)")
            completion(success: false)
        }
    }
    
    func getUserDetail(userID:String,screen_name:String,completion:(success:Bool)->Void){
        let para = ["userID":userID,"screen_name":screen_name]
        GET("1.1/users/show.json", parameters: para, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("succeed:\(response)")
            completion(success: true)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
            completion(success: false)
        }
    }
    
    
}
