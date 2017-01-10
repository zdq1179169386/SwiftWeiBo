//
//  HttpTool.swift
//  WeiBo
//
//  Created by yb on 16/9/21.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import AFNetworking

//枚举类型可以是Int,也可以是String
enum RequestType : String{
    case GET = "GET"
    case POST = "POST"
}

class HttpTool: AFHTTPSessionManager {

    //单例，let是线程安全的
    static let shareInstance : HttpTool = {
    
        let tool = HttpTool()
//        tool.requestSerializer = AFJSONRequestSerializer()
//        tool.responseSerializer = AFJSONResponseSerializer()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tool.responseSerializer.acceptableContentTypes?.insert("application/json")
//        tool.requestSerializer.setValue("application/json,text/html", forHTTPHeaderField: "Accept")
//        tool.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return tool
    }()
}

//MARK:- 封装请求方法
extension HttpTool {
    func request(_ requestType : RequestType, urlString : String, parameters :[String : AnyObject],finished : @escaping (_ result : AnyObject? , _ error : Error?) -> ()) {
        
        let successCallBack = { (task : URLSessionDataTask, result : Any?) in
//            print(result)
            finished(result as AnyObject?, nil)
        }
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) in
//            print(error)
            finished(nil, error)
        }
        
        if requestType == .GET {
            
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }else if requestType == .POST{
            
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}
//MARK:- 获取Token
extension HttpTool{
    func requestForToken(_ code : String,finished : @escaping (_ result : [String : AnyObject]?, _ error : Error?) -> ())  {
        let url = "https://api.weibo.com/oauth2/access_token"
        
        let parameters = ["client_id" : app_key,"client_secret" : app_secret,"grant_type" : "authorization_code","code" : code, "redirect_uri" : redirect_uri]
        
        request(.POST, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject], error)
        }
    }
}
//MARK:- 请求用户数据
extension HttpTool {
    
    func requestForUserInfo(_ accessToken : String,uid : String ,finished : @escaping (_ result : [String : AnyObject]? ,_ error : Error?) -> ()) {
        let url = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token" : accessToken, "uid" : uid]
        
        request(.GET, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject], error)
        }
        
        
        
    }
}
//MARK:- 请求微博数据, [[String : AnyObject]]?  返回的结果类型是数组里包含字典的可选类型
extension HttpTool {
    func loadStatuses(_ since_id: Int ,max_id : Int,finished: @escaping (_ result : [[String : AnyObject]]? , _ error : Error?) -> ())  {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        //OAuthUserTool.shareInstance.account?.access_token是String的可选类型，需要解包
        let access_token = (OAuthUserTool.shareInstance.account?.access_token)!
        let parameters = ["access_token" : access_token,"since_id" : "\(since_id)","max_id" : "\(max_id)"]
        
        request(.GET, urlString: urlStr, parameters: parameters as [String : AnyObject]) { (result, error) in
            
            guard let resultDict = result as? [String : AnyObject] else{
                finished(nil, error)
                return
            }
//            print(resultDict["statuses"])
            //resultDict["statuses"],取出来的还是AnyObject？ ，所以要转成 [[String : AnyObject]]？
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)

        }
        
        
    }
}
//MARK:- 发布微博
extension HttpTool {
    func composeStatus(_ text : String , success : @escaping (_ isSuccess : Bool ,_ error : Error?) -> ()) {
        let url = "https://api.weibo.com/2/statuses/update.json"
        
        let parameters = ["access_token" :(OAuthUserTool.shareInstance.account?.access_token)!, "status" : text]
        
        request(.POST, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            print(error)
            if result != nil{
                success(true,nil)
            }else{
                success(false ,error)
            }
        }
        
        
    }
}
//MARK:- 发布图片微博
extension HttpTool{
    func composePicStatus(_ text : String ,image : UIImage ,success : @escaping (_ isSuccess : Bool,_ error : Error?) -> ()) {
        
        let url = "https://api.weibo.com/2/statuses/upload.json"
        
        let parameters = ["access_token" :(OAuthUserTool.shareInstance.account?.access_token)!, "status" : text]
        
        post(url, parameters: parameters, constructingBodyWith: { (formData) in
            
            if let imgData = UIImageJPEGRepresentation(image, 0.5){
                formData.appendPart(withFileData: imgData,name : "pic",fileName : "123.png" ,mimeType : "image/png")
                
            }
            }, progress: nil, success: { (_, _) in
                success(true, nil)
        }) { (_, error) in
//            let data = error.userInfo["com.alamofire.serialization.response.error.data"] as! Data
//            let errorStr = String.init(data: data, encoding: String.Encoding.utf8)
            
//            print(errorStr)
            success(false, error)
        }
        
        
    }
}
