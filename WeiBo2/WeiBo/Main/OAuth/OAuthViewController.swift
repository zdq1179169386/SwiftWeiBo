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
    
    private func setupUI(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillinClick))
        title = "登录页面"
        
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = NSURL.init(string: str) else{
            return
        }
        webView.loadRequest(NSURLRequest.init(URL: url))
        
    }
}

extension OAuthViewController {
    
    @objc private func closeBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillinClick(){
        print("fillinClick")
        
        let js = "document.getElementById('userId').value='18205623272';document.getElementById('passwd').value='zhl13170015670';"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
        
    }
}

extension OAuthViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        print(error)
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        guard let url = request.URL else{
            return true
        }
        
        let urlString = url.absoluteString
        
        guard urlString.containsString("code=") else{
            return true
        }
        var code = urlString.componentsSeparatedByString("code=").last!
        
        if code.containsString("&") {
            code = code.componentsSeparatedByString("&").first!
        }
        
        print(request,"code=" + code)
        requestForToken(code)
        return true
    }
}

extension OAuthViewController {
    //请求accessToken
    private func requestForToken(code : String){
        
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
    private func requestUserData(account : OAuthUser) {
        
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
            var accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            accountPath = (accountPath as NSString).stringByAppendingPathComponent("account.plist")
            print(accountPath)
            
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            
            OAuthUserTool.shareInstance.account = account
            
            //请求数据成功，退出当前控制器,显示欢迎界面
            self.dismissViewControllerAnimated(false, completion: { 
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })

        }
        
    }
}