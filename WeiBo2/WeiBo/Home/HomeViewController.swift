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
    fileprivate lazy var titleBtn :TitleButton = {
        
        let btn = TitleButton.init()
        btn.setTitle("卑微的尘埃", for: UIControlState())
        return btn
        
    }()
    
    //TipLabel
    fileprivate lazy var tipLabel : UILabel = {
    
        let label = UILabel.init(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 34))
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    ///装微博数据的数组
    fileprivate lazy var statusArray : [StatusViewModel] = [StatusViewModel]()

    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator.init {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visitorView.addRotationAnimation()
        
        self.visitorView.registerBtn.addTarget(self, action: #selector(HomeViewController.register), for: .touchUpInside)
        
        self.visitorView.loginBtn.addTarget(self, action: #selector(HomeViewController.loginClick), for: .touchUpInside)
        
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
    fileprivate func setupNavigationBar(){
    
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: "navigationbar_pop")
        
        self.titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), for: .touchUpInside)
        self.navigationItem.titleView = self.titleBtn
        
    }
    
    fileprivate func setupHeadView(){
        
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("加载中", for: .refreshing)
        header?.setTitle("释放更新", for: .pulling)
        header?.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = header
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    fileprivate func setupFootView(){

        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreData))
    }
    
    fileprivate func setupTipLabel(){
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
    }
    
    fileprivate func setupNotify(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.ShowPhotoBrowser), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}

extension HomeViewController {
//    MARK:- register
    @objc fileprivate func register(){
        print("register")
        
    }
    //    MARK:- loginClick

    @objc fileprivate func loginClick(){

        let oauthVC = OAuthViewController()
        
        let nav = UINavigationController.init(rootViewController: oauthVC)
        
        present(nav, animated: true, completion: nil)
        
    
    }
    //    MARK:- titleBtnClick
    @objc fileprivate func titleBtnClick(_ titleBtn : TitleButton){
//        titleBtn.selected = !titleBtn.selected
        
        let popover = PopoverViewController()
        //如果不加，popover下面的控制器都会消失
        popover.modalPresentationStyle = .custom
        
        //设置自定义转场动画的代理
        //将自定义转场动画抽到单独的popoverAnimator类里
        popover.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 90, y: 55, width: 180, height: 250)

        self.present(popover, animated: true, completion: nil)
        
        print("logintitleBtnClickClick")
    }
    
    @objc fileprivate func ShowPhotoBrowser(_ note : Notification){
        
        let indexPath = (note as NSNotification).userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let urls = (note as NSNotification).userInfo![ShowPhotoBrowserUrlKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        
        
        let vc = PhotoBrowserController.init(index: indexPath, picUrls: urls)
        
        vc.modalPresentationStyle = .custom
        
        vc.transitioningDelegate = photoBrowserAnimator
        //设置弹出和消失动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = vc
        
        present(vc, animated: true, completion: nil)
        
    }
}
//MARK:- 请求微博数据
extension HomeViewController {
    
    
    @objc fileprivate func loadNewData(){
        
        self.loadStatuses(true)
    }
    
    @objc fileprivate func loadMoreData(){
         self.loadStatuses(false)
        
    }
    fileprivate func loadStatuses(_ isNewData : Bool){
        
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
    
    fileprivate  func cacheImage(_ viewModels : [StatusViewModel]) {
    
        //下载图片获取图片的size
        //创建线程组
        let group = DispatchGroup()
        
        for viewModel in viewModels {
            for picUrl in viewModel.picURLs {
                //进入线程组
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl as URL!, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    //离开线程组
                    group.leave()
                })
                
            }
        }
        
        //分线程执行结束之后通知主线程刷新UI
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.showTipLabel(viewModels.count)
        }
        
    }
    
    fileprivate func showTipLabel(_ count : Int){
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "更新了\(count)条新微博"
        
        UIView.animate(withDuration: 1, animations: { 
            
            self.tipLabel.frame.origin.y = 44
            }, completion: { (_) in
                UIView.animate(withDuration: 1, delay: 1, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.isHidden = true
                })
        }) 
    }
    
}
//MARK:- tableView 的代理
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell")! as! HomeStatusCell
        
        let viewModel = statusArray[(indexPath as NSIndexPath).row]
        
        cell.viewModel = viewModel
        cell.deleggate = self
        return cell
        
    }
}

extension HomeViewController : HomeStatusCellDelegate{
    func HomeStatusCellTextClick(_ text: String, range: NSRange) {
        
        let  alert = UIAlertController.init(title: nil, message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


