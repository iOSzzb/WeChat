//
//  TabBarController.swift
//  WeChat
//
//  Created by Harold on 15/7/13.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreData

class TabBarController: UITabBarController ,MessageDelegate{
    
    var saveMessageDelegate:SaveMessageDelegate?
    var hasPassWord:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        var friendListVC:FriendListViewController = FriendListViewController()
        var friendListVCItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 0)
        friendListVC.tabBarItem = friendListVCItem
        var friendListVCNav = UINavigationController(rootViewController: friendListVC)
        
        var topRatedVC = ViewController()
        var topRatedVCItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.TopRated, tag: 1)
        topRatedVC.tabBarItem = topRatedVCItem
        
        var discoverVC = ViewController()
        var discoverVCItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Search, tag: 2)
        discoverVC.tabBarItem = discoverVCItem
        
        var profileVC = ProfileViewController()
        var profileVCItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 3)
        profileVC.tabBarItem = profileVCItem
        
        let viewControllers = [friendListVCNav,topRatedVC,discoverVC,profileVC]
        self.setViewControllers(viewControllers, animated: true)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.messageDelegate = self
        
        let userName = NSUserDefaults.standardUserDefaults().stringForKey(USERNAME)
        let passWord = NSUserDefaults.standardUserDefaults().stringForKey(PASSWORD)

        if userName == nil || passWord == nil {
            self.hasPassWord = false
        }else {
            appDelegate.login()
            self.hasPassWord = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
       super.viewDidAppear(animated)
        (UIApplication.sharedApplication().delegate as! AppDelegate).messageDelegate = self
        
        if self.hasPassWord == false {
            self.showLoginView()
        }
        println("tab bar view apperred")
    }
    
    
    func didReceiveMessage(message:messageInfo){
        println("tab bar receive message")
        AudioServicesPlaySystemSound(10016)
    
        let shareData = DataPersistent.shareDataPersistent()
        
        let receivedMessage = messageInfo(id: 1, messageBody: message.messageBody!, messageImageUrl: "", time: NSDate(), user: message.user!)
        self.saveMessageDelegate?.MessageDidSaved(shareData.insertMessage(receivedMessage))
    }
    
    func showLoginView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController:LoginViewController = storyboard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        self.presentViewController(loginViewController, animated: true) { () -> Void in
            
        }
    }
    
    
}
