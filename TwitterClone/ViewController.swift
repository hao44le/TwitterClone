//
//  ViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit


class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginButton()
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func addLoginButton(){
                
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(){
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> Void in
            if user != nil {
                print(user?.name)
                print(user?.profile_image_url)
            }
            if error != nil {
                
            }
            
            
            
        }
    }
    func getUserTimeline(){
        TwitterClient.sharedInstance.getUserTimeLine { (tweets:[Tweet]?, error) -> Void in
            if tweets != nil {
                for tweet in tweets! {
                    let object = tweet as Tweet
                    print(object.id)
                    print(object.user?.name)
                }
            }
            if error != nil {
                print(error)
            }
        }
    }


}

