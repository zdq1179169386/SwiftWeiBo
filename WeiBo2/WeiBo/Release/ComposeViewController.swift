//
//  ComposeViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/27.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: ComposeTextView!
    
    @IBOutlet weak var picPickerView: PicPickerView!
    
    //懒加载
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var pickerImages : [UIImage] = [UIImage]()
    private lazy var emoticonVc : EmoticonsController = EmoticonsController.init {[weak self] (emoticon) in
    
        //插入表情
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    //toolBar底部的约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerHCons: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupNotify()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//MARK:- 设置UI
extension ComposeViewController {
    private func setupUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .Plain, target: self, action: #selector(ComposeViewController.composeBtnClick))
        navigationItem.rightBarButtonItem?.enabled = false
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
        
        
    }
}
//MARK:- 通知
extension ComposeViewController {
    
    private func setupNotify(){
        //键盘通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.accecptNotify(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        //添加图片通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.PicPickerAddPhotoAction), name: PicPickerAddPhotoNote, object: nil)
        //删除图片通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.PicPickerRemovePhotoAction), name: PicPickerRemovePhotoNote, object: nil)
    }
    
}

extension ComposeViewController {
    @objc private func PicPickerAddPhotoAction(){
        
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        let ipc = UIImagePickerController.init()
        
        ipc.sourceType = .PhotoLibrary
        
        ipc.delegate = self
        
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    
    @objc private func PicPickerRemovePhotoAction(notify : NSNotification){
        
        guard  let image = notify.object as? UIImage else{
            return
        }
        
        
        guard let index = pickerImages.indexOf(image) else{
            return
        }
        
        pickerImages.removeAtIndex(index)
        
        picPickerView.images = pickerImages
        
    }
}
//MARL:- UIImagePickerControllerDelegate
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //加入数组
        pickerImages.append(image)
        //给picPickerView赋值
        self.picPickerView.images = pickerImages
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- 事件监听
extension ComposeViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    @objc private func closeBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //发布按钮
    @objc private func composeBtnClick(){

        textView.resignFirstResponder()

        let text = self.textView.getEmoticonString()
        
        //抽出闭包
        let callBack = { (isSuccess : Bool, error : NSError?) in
            if !isSuccess {
                SVProgressHUD.showErrorWithStatus("\(error!.domain)")
                return
            }
            
            SVProgressHUD.showSuccessWithStatus("发布成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if let image = pickerImages.first {
            //发布图片
            HttpTool.shareInstance.composePicStatus(text, image: image, success: callBack)
        }else{
            //发布文字
            HttpTool.shareInstance.composeStatus(text, success: callBack)
        }
    }
    
    @objc private func accecptNotify(notify : NSNotification){
        
//       print(notify.userInfo)
        
        let duration = (notify.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as! NSTimeInterval
        
        let endFrame = (notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.toolBarBottomCons.constant = UIScreen.mainScreen().bounds.height - endFrame.origin.y

        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    //选择照片
    @IBAction func picPickerClick(sender: AnyObject) {
        //退出键盘
        textView.resignFirstResponder()
        picPickerHCons.constant = UIScreen.mainScreen().bounds.height * 0.60
        UIView.animateWithDuration(0.5) { 
            self.view.layoutIfNeeded()
        }
        
    }
    //选中表情
    @IBAction func emoticonClick(sender: AnyObject) {
        //下去
        textView.resignFirstResponder()
        //替换view
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        //上来
        textView.becomeFirstResponder()
    }
}
//MARK:- UITextViewDelegate
extension ComposeViewController : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        self.textView.placeHolder.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}