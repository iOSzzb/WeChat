//
//  ProfileViewController.swift
//  WeChat
//
//  Created by Harold on 15/7/10.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var logoffBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        logoffBtn = UIButton(frame: CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: 70, height: 33) )
        logoffBtn.setTitle("Log Off", forState: UIControlState.Normal)
        logoffBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        logoffBtn.addTarget(self, action: "logoffBtnOnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoffBtn)
        
        let tabVC = self.tabBarController as? TabBarController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logoffBtnOnClicked(sender:UIButton){
        (UIApplication.sharedApplication().delegate as! AppDelegate).disconnect()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(USERNAME)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(PASSWORD)
        NSUserDefaults.standardUserDefaults().synchronize()
        (UIApplication.sharedApplication().delegate as! AppDelegate).disconnect()
        
        let tabBarVC = self.tabBarController as! TabBarController
        tabBarVC.showLoginView()
    }
    

}
