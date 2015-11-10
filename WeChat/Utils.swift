//
//  Utils.swift
//  WeChat
//
//  Created by Harold on 15/7/6.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func resizableImage(name:String)->UIImage{
        var image:UIImage = UIImage(named: name)!
        
        let top:CGFloat = image.size.height * 0.6
        let bottom:CGFloat = image.size.height * 0.5
        let IAndr:CGFloat = image.size.height * 0.5
        
        return image.resizableImageWithCapInsets(UIEdgeInsets(top: top, left: IAndr, bottom: bottom, right: IAndr))
        
    }
}

extension UILabel {
    
    class func sizeOfSring(string:NSString,font:UIFont,maxWidth:CGFloat)->CGSize{
        var size:CGSize = string.boundingRectWithSize(CGSizeMake(maxWidth, 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
        return CGSizeMake(size.width + 15, size.height + 20)
    }
}