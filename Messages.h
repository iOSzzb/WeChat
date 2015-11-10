//
//  Messages.h
//  WeChat
//
//  Created by Harold on 15/7/23.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Messages.h"

@class Friends;

@interface Messages : NSManagedObject

@property (nonatomic, retain) messageInfo *message;
@property (nonatomic, retain) Friends *friend;

@end
