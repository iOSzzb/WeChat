//
//  Messages.swift
//  WeChat
//
//  Created by Harold on 15/7/21.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation
import CoreData

@objc(Messages)class Messages: NSManagedObject {

    @NSManaged var message: messageInfo
    @NSManaged var friend: Friends

}
