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

    override func viewDidAppear(animated: Bool) {
        if !TwitterClient.sharedInstance.checkUserLogin() {
            removeLoginButton()
            self.performSegueWithIdentifier("showUserTimeline", sender: self)
//            self.addLoginButton()
        } else {
            addLoginButton()
        }
    }
    
    var logInButton : TWTRLogInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func removeLoginButton(){
        if self.logInButton != nil {
            self.logInButton.removeFromSuperview()
        }
    }

    func addLoginButton(){
        
        logInButton = TWTRLogInButton()
        logInButton.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
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
               self.performSegueWithIdentifier("showUserTimeline", sender: self)
                
            }
            if error != nil {
                
            }
            
            
            
        }
    }
    


}




