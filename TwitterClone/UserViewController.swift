//
//  UserViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 10/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit
class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("userID") as? String {
            print(id)
            
            TwitterClient.sharedInstance.getUserDetail(id, screen_name: "hao44le", completion: { (success) -> Void in
                
            })
        }
        
        // Do any additional setup after loading the view.
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
