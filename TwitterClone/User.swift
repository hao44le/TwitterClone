//
//  User.swift
//  TwitterClone
//
//  Created by Gelei Chen on 2/2/2016.
//  Copyright © 2016 Gelei Chen. All rights reserved.
//

import UIKit

public class User: NSObject,NSCoding {
    var name: String?
    var screen_name : String?
    var profile_image_url_https : String?
    var id_str: String?
    var followers_count: NSNumber?
    var favourites_count: NSNumber?
    var profile_background_image_url: String?
    var location : String?
    var friends_count:String?
    var statuses_count:NSNumber?
    var descriptionOfSelf: String?
    
    override init() {
        
    }
    required public init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        self.profile_image_url_https = aDecoder.decodeObjectForKey("profile_image_url_https") as? String
        self.id_str = aDecoder.decodeObjectForKey("id_str") as? String
        self.followers_count = aDecoder.decodeObjectForKey("followers_count") as? NSNumber
        self.favourites_count = aDecoder.decodeObjectForKey("favourites_count") as? NSNumber
        self.profile_background_image_url = aDecoder.decodeObjectForKey("profile_background_image_url") as? String
        self.location = aDecoder.decodeObjectForKey("location") as? String
        self.friends_count = aDecoder.decodeObjectForKey("friends_count") as? String
        self.statuses_count = aDecoder.decodeObjectForKey("statuses_count") as? NSNumber
        self.descriptionOfSelf = aDecoder.decodeObjectForKey("descriptionOfSelf") as? String
//        super.init()
    }
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.screen_name, forKey: "screen_name")
        aCoder.encodeObject(self.profile_image_url_https, forKey: "profile_image_url_https")
        aCoder.encodeObject(self.id_str, forKey: "id_str")
        aCoder.encodeObject(self.followers_count, forKey: "followers_count")
        aCoder.encodeObject(self.favourites_count, forKey: "favourites_count")
        aCoder.encodeObject(self.profile_background_image_url, forKey: "profile_background_image_url")
        aCoder.encodeObject(self.location, forKey: "location")
        aCoder.encodeObject(self.friends_count, forKey: "friends_count")
        aCoder.encodeObject(self.statuses_count, forKey: "statuses_count")
        aCoder.encodeObject(self.descriptionOfSelf, forKey: "descriptionOfSelf")
    }
}
