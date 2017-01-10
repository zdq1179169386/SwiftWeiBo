//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/21.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension OAuthViewController {
    
    fileprivate func setupUI(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillinClick))
        title = "登录页面"
        
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL.init(string: str) else{
            return
        }
        webView.loadRequest(URLRequest.init(url: url))
        
    }
}

extension OAuthViewController {
    
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillinClick(){
        print("fillinClick")
        
        let js = "document.getElementById('userId').value='18205623272';document.getElementById('passwd').value='zhl13170015670';"
        
        webView.stringByEvaluatingJavaScript(from: js)
        
    }
}

extension OAuthViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        print(error)
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        guard let url = request.url else{
            return true
        }
        
        let urlString = url.absoluteString
        
        guard urlString.contains("code=") else{
            return true
        }
        var code = urlString.components(separatedBy: "code=").last!
        
        if code.contains("&") {
            code = code.components(separatedBy: "&").first!
        }
        
        print(request,"code=" + code)
        requestForToken(code)
        return true
    }
}

extension OAuthViewController {
    //请求accessToken
    fileprivate func requestForToken(_ code : String){
        
        HttpTool.shareInstance.requestForToken(code) { (result, error) in
            
            if error != nil{
                print(error)
                return
            }
            print(result)
            guard let accountDict = result else{
                return
            }
            let  user = OAuthUser.init(dict: accountDict)
            print( user)
            self.requestUserData(user)
        }
    }
    //请求用户数据
    fileprivate func requestUserData(_ account : OAuthUser) {
        
        guard let accessToken = account.access_token else{
            
            return
        }
        
        guard let uid = account.uid else {
            return
        }
        
        HttpTool.shareInstance.requestForUserInfo(accessToken, uid: uid) { (result, error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let userInfoDict = result else{
                return
            }
            
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            print(account)
            //将account对象保存
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
            print(accountPath)
            
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            
            OAuthUserTool.shareInstance.account = account
            
            //请求数据成功，退出当前控制器,显示欢迎界面
            self.dismiss(animated: false, completion: { 
                
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })

        }
        
    }
}
