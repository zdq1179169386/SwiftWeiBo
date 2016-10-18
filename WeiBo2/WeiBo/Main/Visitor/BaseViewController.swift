//
//  BaseViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/19.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    ///缓存高度的数组
    private lazy var heightIndexPArray: [NSIndexPath :CGFloat] = [NSIndexPath : CGFloat]()
    
    lazy var visitorView : VisitorView = {
        
        let view = VisitorView.visitorView()
        return view
    }()
    
    //OAuthUserTool，如果不设计成单例，因为BaseViewController下面有4个控制器继承它，每次拿到isLogin进行判断的时候，OAuthUserTool对象就创建4次，占用4分内存，所以设计成单例
    var isLogin : Bool = OAuthUserTool.shareInstance.isLogin
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
        
    }
    
    private func setupVisitorView(){
        
        self.view = visitorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }

}


extension BaseViewController {
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let cellH = heightIndexPArray[indexPath]  {
            
            return cellH
        }else{
            return 200
        }
        
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
        let cellH = cell.frame.size.height
        
        heightIndexPArray[indexPath] = cellH
    }
}