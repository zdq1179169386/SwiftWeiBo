




//
//  EmoticonsController.swift
//  WeiBo
//
//  Created by yb on 16/9/29.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonsController: UIViewController {
    
    var emoticonBack : ((_ emoticon : Emoticon) -> ())?
    
    fileprivate lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmoticonsCollectionViewLayout())
    
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    fileprivate lazy var manager = EmoticonManager()

    //控制器自定义构造函数
    init(emoticonBack : @escaping (_ emoticon : Emoticon) -> () ){
        super.init(nibName: nil, bundle: nil)
        self.emoticonBack = emoticonBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

}

//MARK:- 设置toolBar
extension EmoticonsController {
    
    fileprivate func setupUI(){
        
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.white
//        toolBar.backgroundColor = UIColor.blueColor()
        //设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar" : toolBar,"collectionView" : collectionView] as [String : Any]
        
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        
        view.addConstraints(cons)
        
        prepareForCollectionView()
        
        prepareForToolBar()
        
        
    }
    
    fileprivate func prepareForCollectionView(){
        
        collectionView.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    fileprivate func prepareForToolBar(){
        
        let items = ["最近","默认","emoji","浪小花"]
        var tempItems = [UIBarButtonItem]()
        
        for index in 0 ..< items.count  {
            let item = UIBarButtonItem.init(title: items[index], style: .plain, target: self, action: #selector(EmoticonsController.itemClick(_:)))
            item.tag = index
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        }
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
        
    }
    //ToolBar的点击
    @objc fileprivate func itemClick(_ item : UIBarButtonItem){
        
        let tag = item.tag
        
        let index = IndexPath.init(item: 0, section: tag)
        
        collectionView.scrollToItem(at: index, at: .left, animated: true)
        
    }
}
//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension EmoticonsController:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonCollectionViewCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.brownColor() : UIColor.blackColor()
        let package = manager.packages[(indexPath as NSIndexPath).section]
        
        cell.emoticon = package.emoticons[(indexPath as NSIndexPath).item]
    
        return cell
    }
    //点击表情
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let package = manager.packages[(indexPath as NSIndexPath).section]
        let emoticon = package.emoticons[(indexPath as NSIndexPath).item]
        //插入表情到最近分组
        insertRecentlyEmoticon(emoticon)
        //将表情回调给控制器
        self.emoticonBack!(emoticon)
        
    }
    func insertRecentlyEmoticon(_ emoticon: Emoticon) {
        
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        if manager.packages.first!.emoticons.contains(emoticon) {
            //原来有该表情
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
            
        }else{
            //原来没有该表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
        
    }
    
}

class EmoticonsCollectionViewLayout: UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
        
        let itemWH = UIScreen.main.bounds.width / 7.0
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    
}
