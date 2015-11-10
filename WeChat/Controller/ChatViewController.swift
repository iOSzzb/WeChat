//
//  chatViewController.swift
//  WeChat
//
//  Created by Harold on 15/7/6.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit
import CoreData

class chatViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,InputToolBarDelegate,MessageDelegate{
    
    var tableView:UITableView = UITableView()
    var tableSource:NSMutableArray = []
    var shareData:DataPersistent!
    
    var friend:userInfo = userInfo(id: 0, name: "lucy@zzb.local")
    var hostUser:userInfo = userInfo(id: 1, name: "harold@zzb.local")
    var inputToolbar = InputToolBar(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 44, UIScreen.mainScreen().bounds.width, 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let chatBackground = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        chatBackground.image = UIImage(named: "chat_bg_default")
        self.view.addSubview(chatBackground)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier())
        self.tableView.frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height-self.inputToolbar.frame.height-60)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
        
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 10))
        headerView.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = headerView
        
        self.inputToolbar.delegate = self
        self.view.addSubview(inputToolbar)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
//        (UIApplication.sharedApplication().delegate as! AppDelegate).messageDelegate = self
        println("messageView Did Load")
        
        shareData = DataPersistent.shareDataPersistent()
//        var req = NSFetchRequest(entityName: "Friends")
//        var r = shareData.managedObjectContext?.executeFetchRequest(req, error: nil) as! [Friends]
//        println(r[0].messages)
//        r[0].messages[0].messageBody
//        println(r[0].messages[0].messageBody)

        var request = NSFetchRequest(entityName: "Messages")
        var predict = NSPredicate(format: "self.userName == %@ or self.targetName == %@", friend.name,friend.name)
        request.predicate = predict
        var sort = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [sort]
        var result = shareData.managedObjectContext?.executeFetchRequest(request, error: nil)
        println(result!.count)
        tableSource = NSMutableArray(array: result!)
//        for fri in result{
//            if fri.friendInfo.name == friend.name{
//                tableSource = fri.message
//                tableView.reloadData()
//            }
//        }
        
    }
    
    func setupNavigationTitle(title:String){
        var titleLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width-150, 44))
        titleLabel.text = title
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 18)
        
        self.navigationItem.titleView = titleLabel
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageCell.reuseIdentifier()) as! MessageCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.setupMessageCell(self.tableSource.objectAtIndex(indexPath.row) as! Messages, user: self.hostUser)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MessageCell.heightForCell(self.tableSource.objectAtIndex(indexPath.row) as! Messages)
    }
    
    func onInputBtnTapped(text: String) {
        if text.isEmpty{
            return
        }
//        if (UIApplication.sharedApplication().delegate as! AppDelegate).xmppStream?.isConnected() != true{
//            UIAlertView(title: "提示", message: "与服务器失去连接，请检查你的网络", delegate: nil, cancelButtonTitle: "OK")
//            return
//        }
        if tableSource.count != 0 {
            let lastMessage = self.tableSource.lastObject as! Messages
            let lastId = Int(lastMessage.messageId!)
            let message:messageInfo = messageInfo(id: lastId+1, messageBody: text, messageImageUrl: "", time: NSDate(), user: hostUser)
            message.target = self.friend
            self.tableSource.addObject(shareData.insertMessage(message))
            self.tableView.reloadData()
            let path:NSIndexPath = NSIndexPath(forRow: tableSource.count-1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }else{
            let message:messageInfo = messageInfo(id: 0, messageBody: text, messageImageUrl: "", time: NSDate(), user: hostUser)
            message.target = self.friend
            self.tableSource.addObject(shareData.insertMessage(message))
            self.tableView.reloadData()
        }
        
        sendMessage(text)
    }
    
    func sendMessage(message:String){
        var sendMessage:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        sendMessage.addAttributeWithName("type", stringValue: "chat")
        sendMessage.addAttributeWithName("to", stringValue: self.friend.name)
        sendMessage.addAttributeWithName("from", stringValue: self.hostUser.name)
        var body = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue(message)
        sendMessage.addChild(body)
        (UIApplication.sharedApplication().delegate as! AppDelegate).xmppStream?.sendElement(sendMessage)
    }
    
    func onLeftBtnTapped(text: String) {
        
    }
    
    func keyboardWillChangeFrame(notify:NSNotification){
        
        let userInfo = notify.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.tableView.frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height-self.inputToolbar.frame.height-60-keyboardFrame.height)
            self.inputToolbar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height-44-keyboardFrame.height, UIScreen.mainScreen().bounds.width, 44)
        }) { (finished) -> Void in
            let path:NSIndexPath = NSIndexPath(forRow: self.tableSource.count-1, inSection: 0)
            //可能没有聊天记录，就不需要滚到当前行
            if path.row >= 0 {
                self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
        
        
    }
    
    func keyboardWillHide(notify:NSNotification){
        
        let userInfo = notify.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.tableView.frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height-self.inputToolbar.frame.height-60)
            self.inputToolbar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height-44, UIScreen.mainScreen().bounds.width, 44)
        })
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func chatFriendChange(friend:userInfo){
        self.friend = friend
        self.setupNavigationTitle(self.friend.name!.componentsSeparatedByString("@")[0])
        //self.tableSource.removeAllObjects()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarController.tabBar.hidden = true
        if tableSource.count > 0{
            let indexPatn = NSIndexPath(forRow: tableSource.count-1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPatn, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarController.tabBar.hidden = false
    }
    
    func didReceiveMessage(message:messageInfo){
        
        println("chatView收到消息")
        if message.user!.name == self.friend.name{
            if self.tableSource.count != 0{
                let lastMessage:messageInfo = self.tableSource.lastObject as! messageInfo
                let lastId = lastMessage.messageID
                let receivedMessage = messageInfo(id: lastId!+1, messageBody: message.messageBody!, messageImageUrl: "", time: NSDate(), user: message.user!)
                
                self.tableSource.addObject(receivedMessage)
                self.tableView.reloadData()
                
                let path:NSIndexPath = NSIndexPath(forRow: self.tableSource.count-1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }else{
                let receivedMessage = messageInfo(id: 0, messageBody: message.messageBody!, messageImageUrl: "", time: NSDate(), user: message.user!)
                self.tableSource.addObject(receivedMessage)
                self.tableView.reloadData()
            }
           
        }
    }
    
    func receivedMessage(message:Messages){
        if self.navigationController?.topViewController == self{
            if message.userName == self.friend.name{
                tableSource.addObject(message)
                tableView.reloadData()
                let path:NSIndexPath = NSIndexPath(forRow: self.tableSource.count-1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }


}
