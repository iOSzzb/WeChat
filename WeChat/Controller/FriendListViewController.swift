//
//  FriendListViewController.swift
//  WeChat
//
//  Created by Harold on 15/7/4.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import UIKit
import CoreData

class FriendListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,PresenceDelegate,SaveMessageDelegate{
    
    var tableSource:NSMutableArray = []
    var table:UITableView!
    var chatVC:chatViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let chatBackground = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        chatBackground.image = UIImage(named: "chat_bg_default")
        self.view.addSubview(chatBackground)
        
        table = UITableView(frame: CGRectMake(0, 64, self.view.bounds.width, view.bounds.height))
        table.delegate = self
        table.dataSource = self
        table.registerClass(friendCell.self, forCellReuseIdentifier: friendCell.reuseIdentifier())
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        table.backgroundColor = UIColor.clearColor()
        self.view.addSubview(table)
        
        self.setupNavigationTitle("Friend List")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.presenceDelegate = self
        
        let tabVC = self.tabBarController as? TabBarController
        tabVC?.saveMessageDelegate = self
    }
    
    //MARK:tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendCell.reuseIdentifier()) as! friendCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.setupFriendCell(tableSource[indexPath.row] as! userInfo)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return friendCell.heightForCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var user:userInfo = self.tableSource.objectAtIndex(indexPath.row) as! userInfo
        (self.tableSource.objectAtIndex(indexPath.row) as! userInfo).messageCount = 0
        chatVC = chatViewController()
        chatVC.chatFriendChange(user)

        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    
    func setupNavigationTitle(title:String){
        var titleLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 44))
        titleLabel.text = title
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 28)
        
        self.navigationItem.titleView = titleLabel
        
    }
    
    

    func presenceDidChanged(friend:userInfo){
        println(friend.name)
        for user in self.tableSource{
            if user.name == friend.name{
                return
            }
        }
        self.tableSource.addObject(friend)
        self.table.reloadData()
        
    }

    override func viewWillAppear(animated: Bool) {
        /*
        使用navigationController push，pop Controller的时候，可能不会调用willappear和didappear，在网上我找到两条答案，http://www.idev101.com/code/User_Interface/UINavigationController/viewWillAppear.html
        http://stackoverflow.com/questions/7674958/when-using-a-uinavigationcontroller-the-viewwillappear-or-viewdidappear-methods
        这里我实际调试的结果是，这个视图的willappear一定会调用，而chatViewController的didload一定会调用。
        
        有一点是肯定的:如果当前视图实现了UINavigationControllerDelegate的话，navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) 和 navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
        这两个代理方法是一定会调用的。
        
        如果到下一级的chatViewController的话，AppDelegate中的messageDelegate被重新赋值为chatViewController，为了从chatViewController回到friendlistController还能收到消息，所以要在这里把messageDelegate改回来，这个friendlistController才会收到消息
        */
        println("friend list view will appear")
        self.table.reloadData()
    }
    
    
    //接收到消息可以打一个红点
    func MessageDidSaved(message:Messages){
        println("friend receive message")
        
        if self.chatVC != nil{
            self.chatVC.receivedMessage(message)
        }
        println(message.userName)
        for user in self.tableSource{
            if user.name == message.userName{
                (user as! userInfo).messageCount += 1
            }
        }
        self.table.reloadData()

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
