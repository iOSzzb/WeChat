//
//  friendCell.swift
//  WeChat
//
//  Created by Harold on 15/7/4.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

//自定义的friend cell
class friendCell: UITableViewCell {
    
    var cellBackgroundView:UIView
    var profilePicture:UIImageView
    var nameLable:UILabel
    var tagView:UIView?
    var countLabel:UILabel?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.cellBackgroundView = UIView(frame: CGRectMake(0, 1, UIScreen.mainScreen().bounds.width, 65))
        self.cellBackgroundView.backgroundColor = UIColor.clearColor()
        
        self.profilePicture = UIImageView(frame: CGRectMake(5, 10, 45, 45))
        self.profilePicture.image = UIImage(named: "icon01")
        
        self.nameLable = UILabel(frame: CGRectMake(55, 0, UIScreen.mainScreen().bounds.width - 55, 55))
        self.nameLable.text = "Lily"
        self.nameLable.font = UIFont(name: "ChalkboardSE-Regular", size: 18)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cellBackgroundView.addSubview(profilePicture)
        self.cellBackgroundView.addSubview(nameLable)
        self.addSubview(cellBackgroundView)
        
        self.backgroundColor = UIColor.clearColor()
        self.cellBackgroundView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.cellBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.cellBackgroundView.layer.shadowOpacity = 0.8
        self.cellBackgroundView.layer.shadowPath = CGPathCreateWithRect(self.bounds, nil)
        
        countLabel = UILabel(frame: CGRectMake(35, -10, 20, 20))
       
        countLabel!.textColor = UIColor.whiteColor()
        countLabel!.backgroundColor = UIColor.clearColor()
        countLabel!.textAlignment = NSTextAlignment.Center
        countLabel!.font = UIFont.systemFontOfSize(10)
        tagView?.layer.addSublayer(countLabel!.layer)
        
        self.tagView = UIView(frame: CGRectMake(35, -10, 20, 20))
        self.tagView?.layer.cornerRadius = 10
        self.tagView?.layer.backgroundColor = UIColor.redColor().CGColor
        self.profilePicture.addSubview(self.tagView!)
        self.profilePicture.addSubview(countLabel!)

        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func reuseIdentifier()->String{
        return "friendCell"
    }
    
    class func heightForCell()->CGFloat{
        return 66
    }
    
    func setupFriendCell(user:userInfo){
        if user.name?.isEmpty == true{
            self.nameLable.text = "SomeOne"
        }else{
            let name = user.name?.componentsSeparatedByString("@")[0]
            self.nameLable.text = name
        }
        self.profilePicture.image = UIImage(named: user.profilePicture) 
        if user.status == .on{
        self.cellBackgroundView.backgroundColor = UIColor.orangeColor()
        }else{
            self.cellBackgroundView.backgroundColor = UIColor.grayColor()
        }
        
        if user.messageCount != 0{
            countLabel!.text = "\(user.messageCount)"
            self.tagView?.hidden = false
            self.countLabel?.hidden = false
        }
        else{
            self.tagView?.hidden = true
            self.countLabel?.hidden = true
        }
        
    }

}
