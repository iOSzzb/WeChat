//
//  InputToolBar.swift
//  WeChat
//
//  Created by Harold on 15/7/6.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

//点击按钮事件的代理
protocol InputToolBarDelegate{
    func onInputBtnTapped(text:String)
    func onLeftBtnTapped(text:String)
}

class InputToolBar: UIView ,UITextFieldDelegate{//继承自UIview，实现UItextfield代理，因为用到代理中的方法
    var background:UIImageView//toolBar的背景图片
    var textFieldBackground:UIImageView//textfield的背景
    var textField:UITextField//输入框textFidld
    var leftBtn:UIButton//左边按钮
    var rightBtn:UIButton//右边按钮
    
    var delegate:InputToolBarDelegate?
    
    override init(frame: CGRect) {//初始化的时候要求传一个frame进来，定义这个控件的大小位置
        //初始化各种控件
        self.background = UIImageView()
        self.textFieldBackground = UIImageView()
        self.textField = UITextField()
        self.leftBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        self.rightBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        //调用父类的初始化方法，注意，必须在所有其他控件初始化完成后再执行这段代码（也就是说，要写在上面代码的后面）
        super.init(frame: CGRect())
        
        //设置toolbar的背景图片
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, UIScreen.mainScreen().bounds.width, 44)
        self.background.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.background.image = UIImage.resizableImage("toolbar_bottom_bar")
        addSubview(background)
        
        //设置左按钮
        self.leftBtn.frame = CGRectMake(5, 5, 34, 34)
        self.leftBtn.setBackgroundImage(UIImage(named: "chat_bottom_voice_nor"), forState: UIControlState.Normal)
        self.leftBtn.addTarget(self, action: "onLeftBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(leftBtn)
        
        //设置右按钮
        self.textFieldBackground.frame = CGRectMake(34+10, 5, UIScreen.mainScreen().bounds.width-34-10-34-10, 34)
        self.textFieldBackground.image = UIImage(named: "chat_bottom_textfield")
        addSubview(textFieldBackground)
        
        //设置textfield
        self.textField.frame = CGRectMake(self.textFieldBackground.frame.origin.x+5, 5, self.textFieldBackground.frame.width-10, 34)
        self.textField.borderStyle = UITextBorderStyle.None
        self.textField.backgroundColor = UIColor.clearColor()
        self.textField.placeholder = "请输入..."
        self.textField.delegate = self
        addSubview(textField)
        
        //设置右按钮
        self.rightBtn.frame = CGRectMake(UIScreen.mainScreen().bounds.width-34-5, 5, 34, 34)
        self.rightBtn.setBackgroundImage(UIImage(named: "chat_bottom_up_nor"), forState: UIControlState.Normal)
        self.rightBtn.addTarget(self, action: "onRightBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(rightBtn)
    }
    

    //系统提示添加
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //左按钮点击事件
    func onLeftBtnTapped(sender:AnyObject){
        
    }
    
    //右按钮点击事件
    func onRightBtnTapped(sender:AnyObject){
        self.delegate?.onInputBtnTapped(self.textField.text)//执行代理中的方法，方法实现在chatViewController里
        self.textField.text = ""//点击完成后将输入框置为空
    }
    
    //点击系统键盘的return键会触发此方法
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //调用点击右边按钮的方法
        self.onRightBtnTapped(self.rightBtn)
        return false
    }
    

}
