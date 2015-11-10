//
//  Friends.swift
//  WeChat
//
//  Created by Harold on 15/7/21.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation
import CoreData

@objc(Friends)class Friends: NSManagedObject {

    @NSManaged var friendInfo: userInfo
    
    @NSManaged var messages: NSMutableSet

}
