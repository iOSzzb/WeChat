//
//  AppDelegate.swift
//  WeChat
//
//  Created by Harold on 15/7/3.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit
import CoreData

let USERNAME = "userName"
let PASSWORD = "passWord"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {

    var window: UIWindow?
    
    var tabbarController:UITabBarController!//使用tabbar用于导航
    
    var xmppStream:XMPPStream?//xmppstrem用于与服务器通信
    
    var messageDelegate:MessageDelegate?
    var presenceDelegate:PresenceDelegate?
    var loginSuccessedDelegate:LoginSucceedDelegate?
    var noticeDelegate:NoticeDelegate?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.tabbarController = TabBarController()
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
       
    }
    
    
    func login(){
        self.setupStream()//设置stream
        if self.connect() == false{
            UIAlertView(title: "提示", message: "与服务器连接失败", delegate: nil, cancelButtonTitle: "OK").show()
            println("false")
        }
    }
    
    func setupStream(){
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    func connect()->Bool{
        if xmppStream?.isConnected() == true {
            return true
        }
        var localJID = NSUserDefaults.standardUserDefaults().stringForKey(USERNAME)
        var localPassword = NSUserDefaults.standardUserDefaults().stringForKey(PASSWORD)
        
        if localJID==nil||localPassword==nil{
            return false
        }
        
        xmppStream?.myJID = XMPPJID.jidWithString(localJID)
        xmppStream?.hostName = "localhost"
        
        if xmppStream?.connectWithTimeout(500, error: nil) == nil {
            return false
        }else{
          return true
        }
        //return true
    }
    
    //链接服务器成功后会调用这个函数
    func xmppStreamDidConnect(sender: XMPPStream!) {
        //验证密码授权
        
        xmppStream?.authenticateWithPassword(NSUserDefaults.standardUserDefaults().stringForKey(PASSWORD), error: nil)
    }
    
    //验证完成后会调用这个代理函数
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        self.goOnline()
    }
    //验证失败，弹窗提示
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        UIAlertView(title: "提示", message: "用户名或密码错误", delegate: nil, cancelButtonTitle: "OK").show()
                    NSUserDefaults.standardUserDefaults().removeObjectForKey(PASSWORD)
    }
    
    func goOnline(){
        var presence:XMPPPresence = XMPPPresence()
        var domain = xmppStream?.myJID.domain
        //发送状态
        xmppStream?.sendElement(presence)
        loginSuccessedDelegate?.loginSucceed()
    }
    
    //在接收到状态改变后会调用这个代理函数
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        if sender.myJID.user != presence.from().user{
            let tempName = presence.from().user + "@" + presence.from().domain
            var friend:userInfo = userInfo(id: 1, name: tempName)
            if friend.name == "lily@zzb.local" {
                friend.profilePicture = "lily"
            }else {
                friend.profilePicture = "lucy"
            }
            let preseceType = presence.type()
            
            if preseceType == "available"{
                friend.status = isOnline.on
            }else if preseceType == "unavailable"{
                friend.status = isOnline.off
            }
            self.presenceDelegate?.presenceDidChanged(friend)//这个代理函数，在friendListViewController里实现
        }
    }
    
    //在接受到消息时会调用这个代理函数
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        if message.isChatMessage(){
            var chatMessage = messageInfo()
            let tempName = message.from().user + "@" + message.from().domain
            chatMessage.user = userInfo(id: 1, name: tempName)
            let tempTarget = message.to().user + "@" + message.to().domain
            chatMessage.target = userInfo(id: 2, name: tempTarget)
            
            if message.elementForName("composing") != nil {
                chatMessage.messageStatus = MessageStatus.composing
            }
            if message.elementForName("delay") != nil {
                chatMessage.messageStatus = MessageStatus.delay
            }
            if message.body() != nil {
                chatMessage.messageBody = message.body()
            }
            if let tempBody = message.elementForName("body"){
                chatMessage.messageBody = tempBody.stringValue()
            }
            
            self.messageDelegate?.didReceiveMessage(chatMessage)
            
            //提示friendlistView收到了一条消息。本来在friendlistView也实现了messageDelegate?.didReceiveMessage，但是调试中发现，在chatView出现后，friendlistView实现的代理方法就无用了，不得已又写了一个代理。
            //也就是说可能两个ViewController都实现同一个代理方法，这种方式可能是不行的。
            self.noticeDelegate?.receiveOneMessage(chatMessage)
        }
    }
    
    func disconnect(){
        self.goOffline()
        xmppStream?.disconnect()
       
    }
    
    func goOffline(){
        var presence = XMPPPresence(type: "unavailable")
        xmppStream?.sendElement(presence)
    }
    
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        println(error)
    }
    
    
    
    
}


