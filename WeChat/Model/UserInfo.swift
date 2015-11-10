//
//  userInfo.swift
//  WeChat
//
//  Created by Harold on 15/7/4.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

enum userGender:String{
    case male = "male"
    case female = "female"
    case unknown = "unknown"
}

enum isOnline:Int{
    case off = 0
    case on = 1
    case unKnown = 3
}

class userInfo:NSObject ,NSCoding{
    
    var id:Int?
    var name:String!
    var nickName:String = ""
    var messageCount:Int = 0
    var gender = userGender.male
    var status = isOnline.on
    var selfdescription = ""
    var signature = ""
    var profilePicture = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as! String
    }
    
    init(id:Int,name:String){
        self.id = id
        self.name = name
    }
    
}
