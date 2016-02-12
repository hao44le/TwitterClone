//
//  SettingTableViewController.swift
//  TwitterClone
//
//  Created by Gelei Chen on 11/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit

class SettingTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

   
    @IBAction func addClicked(sender: AnyObject) {
        login()
    }
    @IBAction func doneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func login(){
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> Void in
            if user != nil {
//                print(self.users)
                self.reloadData()
                NSNotificationCenter.defaultCenter().postNotificationName("userDidSwitchAccount", object: nil)
            }
            if error != nil {
                Tool.showErrorHUD("Login Failed")
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    func reloadData(){
        if let array = NSUserDefaults.standardUserDefaults().objectForKey("userArray") as? [NSData] {
            self.users.removeAll()
            for element in array {
                let unarc = NSKeyedUnarchiver(forReadingWithData: element)
                unarc.setClass(User.self, forClassName: "User")
                let user = unarc.decodeObjectForKey("root") as! User
                self.users.append(user)
            }
            self.tableView.reloadData()
            
        }

    }
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserTableViewCell
        let user = self.users[indexPath.row]
        if user.profile_image_url_https != nil {
            cell.userImage!.sd_setImageWithURL(NSURL(string: user.profile_image_url_https!), placeholderImage: UIImage(named: "placeholder.jpg"))
        } else {
            cell.userImage?.image = UIImage(named: "placeholder.jpg")
        }
        cell.userName.text = user.name
        cell.userScreenName.text = "@\(user.screen_name!)"
        

        // Configure the cell...

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let credential = self.users[indexPath.row].credientail
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(credential)
        Twitter.sharedInstance().sessionStore.saveSessionWithAuthToken(credential!.token, authTokenSecret: credential!.secret, completion: { (session:TWTRAuthSession?, error:NSError?) -> Void in
            print("save to session store")
            print("error:\(error)")
            
        })
        NSNotificationCenter.defaultCenter().postNotificationName("userDidSwitchAccount", object: nil)
        NSUserDefaults.standardUserDefaults().setValue(NSKeyedArchiver.archivedDataWithRootObject(self.users[indexPath.row]), forKey: "userObject")
        NSUserDefaults.standardUserDefaults().setValue(credential!.userInfo, forKey: "userID")

    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if self.users.count == 1 {
            return false
        }
        return true
    }


    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.users.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
            if var array = NSUserDefaults.standardUserDefaults().objectForKey("userArray") as? [NSData] {
                array.removeAtIndex(indexPath.row)
                NSUserDefaults.standardUserDefaults().setObject(array, forKey: "userArray")
                
                
            }
            
        }  
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
