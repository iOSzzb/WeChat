//
//  MessageCell.swift
//  WeChat
//
//  Created by Harold on 15/7/6.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

let profilePictureSize:CGSize = CGSize(width: 45, height: 45)

//自定义的消息cell
class MessageCell: UITableViewCell {
    
    var profilePicture:UIImageView
    var messageLabel:UILabel
    var messageBackGround:UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        profilePicture = UIImageView()
        messageLabel = UILabel()
        messageBackGround = UIImageView()
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.numberOfLines = 0
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageBackGround)
        self.addSubview(profilePicture)
        self.messageBackGround.addSubview(messageLabel)
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func heightForCell(message:Messages)->CGFloat{
        
        let screenRect = UIScreen.mainScreen().bounds
        
        let labelSize:CGSize = UILabel.sizeOfSring(message.message!, font: UIFont.systemFontOfSize(16), maxWidth: screenRect.width - profilePictureSize.width*2 - 10 - 20)
        if labelSize.height < profilePictureSize.height + 10 {
            return profilePictureSize.height + 10
        }else{
            return labelSize.height + 5
        }
        
    }
    
    class func reuseIdentifier()->String{
        return "MessageCell"
    }
    
    
    func setupMessageCell(message:Messages,user:userInfo){
        let screenRect = UIScreen.mainScreen().bounds
        let labelSize:CGSize = UILabel.sizeOfSring(message.message!, font:self.messageLabel.font, maxWidth: screenRect.width - profilePictureSize.width*2 - 10 - 20)
        let messageBackGroundSize:CGSize = CGSizeMake(labelSize.width + 25, labelSize.height)
        
        if message.userName == user.name{
            self.profilePicture.frame = CGRectMake(screenRect.width - 5 - profilePictureSize.width, 5, profilePictureSize.width, profilePictureSize.height)
            self.profilePicture.image = UIImage(named: "icon03")
            
            self.messageLabel.text = message.message
            self.messageLabel.frame = CGRectMake(10, 0, labelSize.width, labelSize.height)
            self.messageLabel.textAlignment = NSTextAlignment.Left
            
            self.messageBackGround.image = UIImage.resizableImage("chatto_bg_normal")
            self.messageBackGround.frame = CGRectMake(screenRect.width  - messageBackGroundSize.width-profilePictureSize.width - 5 - 5, 5, messageBackGroundSize.width, messageBackGroundSize.height)
            
        }else{
            self.profilePicture.frame = CGRectMake(5, 5, profilePictureSize.width, profilePictureSize.height)
            self.profilePicture.image = UIImage(named:message.userName!.componentsSeparatedByString("@") [0])
            
            self.messageLabel.text = message.message
            self.messageLabel.frame = CGRectMake(20, 0, labelSize.width, labelSize.height)
            self.messageLabel.textAlignment = NSTextAlignment.Left
            
            self.messageBackGround.image = UIImage.resizableImage("chatfrom_bg_normal")
            self.messageBackGround.frame = CGRectMake(self.profilePicture.frame.origin.x + self.profilePicture.frame.width + 5, 5, messageBackGroundSize.width, messageBackGroundSize.height)
            
        }
    
    
    }

}
