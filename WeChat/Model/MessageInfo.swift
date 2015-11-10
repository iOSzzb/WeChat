//
//  messageInfo.swift
//  WeChat
//
//  Created by Harold on 15/7/6.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

enum MessageStatus:Int{
    case composing = 0
    case delay = 1
    case unknown = 2
}

class messageInfo: NSObject ,NSCoding{
    
    var messageID:Int?
    var messageBody:String?
    var messageImageUrl:String?
    var messageTime:NSDate?
    var messageStatus:MessageStatus = MessageStatus.unknown
    
    var user:userInfo?
    var target:userInfo?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.messageID, forKey: "id")
        aCoder.encodeObject(self.messageBody, forKey: "body")
        aCoder.encodeObject(self.messageImageUrl, forKey: "ImageUrl")
        aCoder.encodeObject(self.messageTime, forKey: "Time")
        
        aCoder.encodeObject(self.user, forKey: "user")
        aCoder.encodeObject(self.target, forKey: "target")
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.messageID = aDecoder.decodeObjectForKey("id") as? Int
        self.messageBody = aDecoder.decodeObjectForKey("body") as? String
        self.messageImageUrl = aDecoder.decodeObjectForKey("ImageUrl") as? String
        self.messageTime = aDecoder.decodeObjectForKey("Time") as? NSDate
        self.user = aDecoder.decodeObjectForKey("user") as? userInfo
        self.target = aDecoder.decodeObjectForKey("target") as? userInfo
    }

    
    override init() {
        messageID = 0
        messageBody = ""
        messageImageUrl = ""
        messageTime = NSDate()
    }
    
    init(id:Int,messageBody:String,messageImageUrl:String,time:NSDate,user:userInfo){
        self.messageID = id
        self.messageBody = messageBody
        self.messageImageUrl = messageImageUrl
        self.messageTime = time
        self.user = user
    }
    
    

}
