//
//  HomeViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/18.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    

    ///导航的标题
    private lazy var titleBtn :TitleButton = {
        
        let btn = TitleButton.init()
        btn.setTitle("卑微的尘埃", forState: .Normal)
        return btn
        
    }()
    
    //TipLabel
    private lazy var tipLabel : UILabel = {
    
        let label = UILabel.init(frame: CGRectMake(0, 10, UIScreen.mainScreen().bounds.width, 34))
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        return label
    }()
    
    ///装微博数据的数组
    private lazy var statusArray : [StatusViewModel] = [StatusViewModel]()

    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator.init {[weak self] (presented) in
        self?.titleBtn.selected = presented
    }
    private lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visitorView.addRotationAnimation()
        
        self.visitorView.registerBtn.addTarget(self, action: #selector(HomeViewController.register), forControlEvents: .TouchUpInside)
        
        self.visitorView.loginBtn.addTarget(self, action: #selector(HomeViewController.loginClick), forControlEvents: .TouchUpInside)
        
        self.setupNavigationBar()
        
        if tableView == nil {
            return
        }

        //自动计算高度
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //设置下拉刷新
        self.setupHeadView()
        //设置上拉更多
        self.setupFootView()
        //设置提示Label
        setupTipLabel()
        //监听通知
        setupNotify()

    }
    
    
    deinit{
        print("deinit")
    }

}
//    MARK:- 设置UI
extension HomeViewController {
    private func setupNavigationBar(){
    
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: "navigationbar_pop")
        
        self.titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = self.titleBtn
        
    }
    
    private func setupHeadView(){
        
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("加载中", forState: .Refreshing)
        header.setTitle("释放更新", forState: .Pulling)
        header.lastUpdatedTimeLabel.hidden = true
        self.tableView.mj_header = header
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    private func setupFootView(){

        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreData))
    }
    
    private func setupTipLabel(){
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
    }
    
    private func setupNotify(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.ShowPhotoBrowser), name: ShowPhotoBrowserNote, object: nil)
    }
}

extension HomeViewController {
//    MARK:- register
    @objc private func register(){
        print("register")
        
    }
    //    MARK:- loginClick

    @objc private func loginClick(){

        let oauthVC = OAuthViewController()
        
        let nav = UINavigationController.init(rootViewController: oauthVC)
        
        presentViewController(nav, animated: true, completion: nil)
        
    
    }
    //    MARK:- titleBtnClick
    @objc private func titleBtnClick(titleBtn : TitleButton){
//        titleBtn.selected = !titleBtn.selected
        
        let popover = PopoverViewController()
        //如果不加，popover下面的控制器都会消失
        popover.modalPresentationStyle = .Custom
        
        //设置自定义转场动画的代理
        //将自定义转场动画抽到单独的popoverAnimator类里
        popover.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRectMake(UIScreen.mainScreen().bounds.size.width * 0.5 - 90, 55, 180, 250)

        self.presentViewController(popover, animated: true, completion: nil)
        
        print("logintitleBtnClickClick")
    }
    
    @objc private func ShowPhotoBrowser(note : NSNotification){
        
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! NSIndexPath
        let urls = note.userInfo![ShowPhotoBrowserUrlKey] as! [NSURL]
        let object = note.object as! PicCollectionView
        
        
        
        let vc = PhotoBrowserController.init(index: indexPath, picUrls: urls)
        
        vc.modalPresentationStyle = .Custom
        
        vc.transitioningDelegate = photoBrowserAnimator
        //设置弹出和消失动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = vc
        
        presentViewController(vc, animated: true, completion: nil)
        
    }
}
//MARK:- 请求微博数据
extension HomeViewController {
    
    
    @objc private func loadNewData(){
        
        self.loadStatuses(true)
    }
    
    @objc private func loadMoreData(){
         self.loadStatuses(false)
        
    }
    private func loadStatuses(isNewData : Bool){
        
        var since_id = 0 , max_id = 0
        
        
        if isNewData {
            
            since_id = statusArray.first?.status?.mid ?? 0
            
        }else{
            max_id = statusArray.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        
        HttpTool.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error) in
            if error != nil{
                print(error)
                self.tableView.mj_header.endEditing(true)
                self.tableView.mj_footer.endEditing(true)
                return
            }
            
            //            print(result)
            
            guard let resultArray = result else{
                return
            }
            //数据解析
            var tempArray = [StatusViewModel]()
            for resultDict in resultArray{
                
                let status = Status.init(dict: resultDict)
                let viewModel = StatusViewModel.init(status: status)
                tempArray.append(viewModel)
            }
            
            if isNewData{
                //下拉拼接在数组的最前面
                self.statusArray = tempArray + self.statusArray
                
            }else{
                //上拉拼接在数组的最后面
                self.statusArray += tempArray
            }
            
            //缓存图片
            self.cacheImage(tempArray)
            //            //刷新表
            //            self.tableView.reloadData()
        }
        
    }
    
    private  func cacheImage(viewModels : [StatusViewModel]) {
    
        //下载图片获取图片的size
        //创建线程组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            for picUrl in viewModel.picURLs {
                //进入线程组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    //离开线程组
                    dispatch_group_leave(group)
                })
                
            }
        }
        
        //分线程执行结束之后通知主线程刷新UI
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.showTipLabel(viewModels.count)
        }
        
    }
    
    private func showTipLabel(count : Int){
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "更新了\(count)条新微博"
        
        UIView.animateWithDuration(1, animations: { 
            
            self.tipLabel.frame.origin.y = 44
            }) { (_) in
                UIView.animateWithDuration(1, delay: 1, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
        }
    }
    
}
//MARK:- tableView 的代理
extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell")! as! HomeStatusCell
        
        let viewModel = statusArray[indexPath.row]
        
        cell.viewModel = viewModel
        cell.deleggate = self
        return cell
        
    }
}

extension HomeViewController : HomeStatusCellDelegate{
    func HomeStatusCellTextClick(text: String, range: NSRange) {
        
        let  alert = UIAlertController.init(title: nil, message: text, preferredStyle: .Alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .Default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}


