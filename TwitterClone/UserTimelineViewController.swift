//
//  1.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit
import TwitterKit

class UserTimelineViewController: TWTRTimelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let store = Twitter.sharedInstance().sessionStore
        
        let client = TWTRAPIClient(userID: store.session()!.userID)
        self.dataSource = TWTRUserTimelineDataSource(screenName: "fabric", APIClient: client)
    }
}
