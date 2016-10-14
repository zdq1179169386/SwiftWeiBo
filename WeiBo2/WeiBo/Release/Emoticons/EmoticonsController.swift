




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
    
    var emoticonBack : ((emoticon : Emoticon) -> ())?
    
    private lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: EmoticonsCollectionViewLayout())
    
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()

    //控制器自定义构造函数
    init(emoticonBack : (emoticon : Emoticon) -> () ){
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
    
    private func setupUI(){
        
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.whiteColor()
//        toolBar.backgroundColor = UIColor.blueColor()
        //设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar" : toolBar,"collectionView" : collectionView]
        
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.AlignAllLeft,.AlignAllRight], metrics: nil, views: views)
        
        view.addConstraints(cons)
        
        prepareForCollectionView()
        
        prepareForToolBar()
        
        
    }
    
    private func prepareForCollectionView(){
        
        collectionView.registerClass(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func prepareForToolBar(){
        
        let items = ["最近","默认","emoji","浪小花"]
        var tempItems = [UIBarButtonItem]()
        
        for index in 0 ..< items.count  {
            let item = UIBarButtonItem.init(title: items[index], style: .Plain, target: self, action: #selector(EmoticonsController.itemClick(_:)))
            item.tag = index
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        }
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
        
    }
    //ToolBar的点击
    @objc private func itemClick(item : UIBarButtonItem){
        
        let tag = item.tag
        
        let index = NSIndexPath.init(forItem: 0, inSection: tag)
        
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Left, animated: true)
        
    }
}
//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension EmoticonsController:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonCell, forIndexPath: indexPath) as! EmoticonCollectionViewCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.brownColor() : UIColor.blackColor()
        let package = manager.packages[indexPath.section]
        
        cell.emoticon = package.emoticons[indexPath.item]
    
        return cell
    }
    //点击表情
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //插入表情到最近分组
        insertRecentlyEmoticon(emoticon)
        //将表情回调给控制器
        self.emoticonBack!(emoticon: emoticon)
        
    }
    func insertRecentlyEmoticon(emoticon: Emoticon) {
        
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        if manager.packages.first!.emoticons.contains(emoticon) {
            //原来有该表情
            let index = (manager.packages.first?.emoticons.indexOf(emoticon))!
            manager.packages.first?.emoticons.removeAtIndex(index)
            
        }else{
            //原来没有该表情
            manager.packages.first?.emoticons.removeAtIndex(19)
        }
        manager.packages.first?.emoticons.insert(emoticon, atIndex: 0)
        
    }
    
}

class EmoticonsCollectionViewLayout: UICollectionViewFlowLayout{
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let itemWH = UIScreen.mainScreen().bounds.width / 7.0
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    
}
