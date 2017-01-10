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
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var pickerImages : [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc : EmoticonsController = EmoticonsController.init {[weak self] (emoticon) in
    
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
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:- 设置UI
extension ComposeViewController {
    fileprivate func setupUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(ComposeViewController.composeBtnClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
        
        
    }
}
//MARK:- 通知
extension ComposeViewController {
    
    fileprivate func setupNotify(){
        //键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.accecptNotify(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //添加图片通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.PicPickerAddPhotoAction), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //删除图片通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.PicPickerRemovePhotoAction), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
    
}

extension ComposeViewController {
    @objc fileprivate func PicPickerAddPhotoAction(){
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        let ipc = UIImagePickerController.init()
        
        ipc.sourceType = .photoLibrary
        
        ipc.delegate = self
        
        present(ipc, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func PicPickerRemovePhotoAction(_ notify : Notification){
        
        guard  let image = notify.object as? UIImage else{
            return
        }
        
        
        guard let index = pickerImages.index(of: image) else{
            return
        }
        
        pickerImages.remove(at: index)
        
        picPickerView.images = pickerImages
        
    }
}
//MARL:- UIImagePickerControllerDelegate
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //加入数组
        pickerImages.append(image)
        //给picPickerView赋值
        self.picPickerView.images = pickerImages
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- 事件监听
extension ComposeViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    //发布按钮
    @objc fileprivate func composeBtnClick(){

        textView.resignFirstResponder()

        let text = self.textView.getEmoticonString()
        
        //抽出闭包
        let callBack = { (isSuccess : Bool, error : Error?) in
            if !isSuccess {
//                SVProgressHUD.showError(withStatus: "\(error!.domain)")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布成功")
            self.dismiss(animated: true, completion: nil)
        }
        
        if let image = pickerImages.first {
            //发布图片
            HttpTool.shareInstance.composePicStatus(text, image: image, success: callBack)
        }else{
            //发布文字
            HttpTool.shareInstance.composeStatus(text, success: callBack)
        }
    }
    
    @objc fileprivate func accecptNotify(_ notify : Notification){
        
//       print(notify.userInfo)
        
        let duration = ((notify as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey]) as! TimeInterval
        
        let endFrame = ((notify as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.toolBarBottomCons.constant = UIScreen.main.bounds.height - endFrame.origin.y

        UIView.animate(withDuration: duration, animations: { 
            self.view.layoutIfNeeded()
        }) 
        
    }
    
    //选择照片
    @IBAction func picPickerClick(_ sender: AnyObject) {
        //退出键盘
        textView.resignFirstResponder()
        picPickerHCons.constant = UIScreen.main.bounds.height * 0.60
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.layoutIfNeeded()
        }) 
        
    }
    //选中表情
    @IBAction func emoticonClick(_ sender: AnyObject) {
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
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.placeHolder.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
