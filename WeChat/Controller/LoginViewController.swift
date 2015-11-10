//
//  loginViewController.swift
//  WeChat
//
//  Created by Harold on 15/7/3.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

//let USERNAME = "username"
//let PASSWORD = "password"

class LoginViewController: UIViewController ,UIScrollViewDelegate,UITextFieldDelegate,LoginSucceedDelegate{
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginBGImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        let screenRect = UIScreen.mainScreen().bounds
        self.scrollView.contentSize = CGSizeMake(screenRect.width, screenRect.height + 1.0)
        
        self.loginLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 40)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.loginSuccessedDelegate = self
        
    }
    
    @IBAction func doneBtnClicked(sender: UIButton) {
        
        //判断用户名和密码是否为空
        if self.usernameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty{
            UIAlertView(title: "提示", message: "用户名和密码不能为空", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        //去掉用户输入时系统可能添加的空格
        var trimUsername = self.usernameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var trimPassworld = self.passwordTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var name = trimUsername + "@zzb.local"
        
        //将用户名和密码存储到userdefaults里
        NSUserDefaults.standardUserDefaults().setValue(name, forKey: USERNAME)
        NSUserDefaults.standardUserDefaults().setValue(trimPassworld, forKey: PASSWORD)
        NSUserDefaults.standardUserDefaults().synchronize()
        //下面就可以登录了，登录的时候可以加一些限制条件
        (UIApplication.sharedApplication().delegate as! AppDelegate).login()
        let presentingVC = self.presentingViewController as! TabBarController
        presentingVC.hasPassWord = true
        
    }
    
    func loginSucceed() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
           
        })
    }
    
    // MARK:UITextFieldDelegate
    //当键盘上的return键点击了会触发这个函数
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField{
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        }else{
            self.passwordTextField.resignFirstResponder()
            self.doneBtnClicked(self.doneButton)
        }
        
        return true
    }
    
    // MARK:UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //背景图片的移动比其他控件慢一半
        var offect = scrollView.contentOffset.y/2
        var transform = CGAffineTransformMakeTranslation(0, offect)
        self.loginBGImageView.transform = transform
        //收起键盘
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
