//
//  Tweet.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user : User?
    var text : String?
    var created_at : String?
    var favorited : String?
    var retweeted : String?
    var retweet_count : NSNumber?
    var retweeted_status : Tweetretweeted_status?
    var id : NSNumber?
}
class Tweetretweeted_status : NSObject {
    var favorite_count : NSNumber?
}
