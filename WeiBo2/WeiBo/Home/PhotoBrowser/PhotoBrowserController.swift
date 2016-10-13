



//
//  PhotoBrowserController.swift
//  WeiBo
//
//  Created by yb on 16/10/12.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class PhotoBrowserController: UIViewController {
    
    var index : NSIndexPath
    var picUrls : [NSURL]
    
    //MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    private lazy var saveBtn : UIButton = UIButton()
    //自定义构造函数
    
    init(index : NSIndexPath , picUrls : [NSURL]){
        self.index = index
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // 2.滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Left, animated: false)

    }


    private func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.registerClass(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: "PhotoBrowserCell")
        
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.backgroundColor = UIColor.darkGrayColor()
        saveBtn.setTitle("保存", forState: .Normal)
        saveBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveClick), forControlEvents: .TouchUpInside)
    }

}
//MARK:-事件点击
extension PhotoBrowserController {
    @objc private func saveClick(){
        
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        guard let img = cell.imageView.image else{
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    //要将上面的oc方法转成swift
    @objc private func image(image : UIImage,didFinishSavingWithError error : NSError?,contextInfo : AnyObject){
        if error != nil {
            SVProgressHUD.showErrorWithStatus(error?.domain)
        }else{
            SVProgressHUD.showSuccessWithStatus("保存成功")
        }
    }
}

extension PhotoBrowserController :UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
         return picUrls.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBrowserCell", forIndexPath: indexPath) as! PhotoBrowserViewCell
        
        cell.picURL = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    
    }

}
//MARK: - PhotoBrowserViewCellDelegate
extension PhotoBrowserController : PhotoBrowserViewCellDelegate{
    func imageClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}
//MARK:- 实现代理方法 AnimatorDismissDelegate
extension PhotoBrowserController :AnimatorDismissDelegate {
    func indexPathForDismissView() -> NSIndexPath {
        
        let cell = collectionView.visibleCells().first!
        return collectionView.indexPathForCell(cell)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imgView = UIImageView()
        
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        imgView.frame = cell.imageView.frame
        imgView.image = cell.imageView.image
        
        imgView.contentMode = .ScaleToFill
        imgView.clipsToBounds = true
        
        return imgView
    }

}