//
//  Messages.swift
//  WeChat
//
//  Created by Harold on 15/7/23.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation
import CoreData

@objc(Messages)class Messages: NSManagedObject {

    @NSManaged var message: String?
    @NSManaged var userName: String?
    @NSManaged var userId: NSNumber?
    @NSManaged var time: NSDate?
    @NSManaged var targetName: String?
    @NSManaged var imageUrl: String?
    @NSManaged var messageId: NSNumber?

}
