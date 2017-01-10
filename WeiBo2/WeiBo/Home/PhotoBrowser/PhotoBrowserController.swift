



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
    
    var index : IndexPath
    var picUrls : [URL]
    
    //MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    fileprivate lazy var saveBtn : UIButton = UIButton()
    //自定义构造函数
    
    init(index : IndexPath , picUrls : [URL]){
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
        collectionView.scrollToItem(at: index, at: .left, animated: false)

    }


    fileprivate func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: "PhotoBrowserCell")
        
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.backgroundColor = UIColor.darkGray
        saveBtn.setTitle("保存", for: UIControlState())
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveClick), for: .touchUpInside)
    }

}
//MARK:-事件点击
extension PhotoBrowserController {
    @objc fileprivate func saveClick(){
        
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let img = cell.imageView.image else{
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    //要将上面的oc方法转成swift
    @objc fileprivate func image(_ image : UIImage,didFinishSavingWithError error : NSError?,contextInfo : AnyObject){
        if error != nil {
            SVProgressHUD.showError(withStatus: error?.domain)
        }else{
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
}

extension PhotoBrowserController :UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
         return picUrls.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowserCell", for: indexPath) as! PhotoBrowserViewCell
        
        cell.picURL = picUrls[(indexPath as NSIndexPath).item]
        cell.delegate = self
        return cell
    
    }

}
//MARK: - PhotoBrowserViewCellDelegate
extension PhotoBrowserController : PhotoBrowserViewCellDelegate{
    func imageClick() {
        dismiss(animated: true, completion: nil)
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}
//MARK:- 实现代理方法 AnimatorDismissDelegate
extension PhotoBrowserController :AnimatorDismissDelegate {
    func indexPathForDismissView() -> IndexPath {
        
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imgView = UIImageView()
        
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imgView.frame = cell.imageView.frame
        imgView.image = cell.imageView.image
        
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        
        return imgView
    }

}
