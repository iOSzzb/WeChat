//
//  MessageDelegate.swift
//  WeChat
//
//  Created by Harold on 15/7/10.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation

protocol MessageDelegate{
    func didReceiveMessage(message:messageInfo)
}
