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
    func request(requestType : RequestType, urlString : String, parameters :[String : AnyObject],finished : (result : AnyObject? , error : NSError?) -> ()) {
        
        let successCallBack = { (task : NSURLSessionDataTask, result : AnyObject?) in
//            print(result)
            finished(result: result, error: nil)
        }
        let failureCallBack = { (task : NSURLSessionDataTask?, error : NSError) in
//            print(error)
            finished(result: nil, error: error)
        }
        
        if requestType == .GET {
            
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }else if requestType == .POST{
            
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}
//MARK:- 获取Token
extension HttpTool{
    func requestForToken(code : String,finished : (result : [String : AnyObject]?, error : NSError?) -> ())  {
        let url = "https://api.weibo.com/oauth2/access_token"
        
        let parameters = ["client_id" : app_key,"client_secret" : app_secret,"grant_type" : "authorization_code","code" : code, "redirect_uri" : redirect_uri]
        
        request(.POST, urlString: url, parameters: parameters) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}
//MARK:- 请求用户数据
extension HttpTool {
    
    func requestForUserInfo(accessToken : String,uid : String ,finished : (result : [String : AnyObject]? ,error : NSError?) -> ()) {
        let url = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token" : accessToken, "uid" : uid]
        
        request(.GET, urlString: url, parameters: parameters) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
        
        
        
    }
}
//MARK:- 请求微博数据, [[String : AnyObject]]?  返回的结果类型是数组里包含字典的可选类型
extension HttpTool {
    func loadStatuses(since_id: Int ,max_id : Int,finished: (result : [[String : AnyObject]]? , error : NSError?) -> ())  {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        //OAuthUserTool.shareInstance.account?.access_token是String的可选类型，需要解包
        let access_token = (OAuthUserTool.shareInstance.account?.access_token)!
        let parameters = ["access_token" : access_token,"since_id" : "\(since_id)","max_id" : "\(max_id)"]
        
        request(.GET, urlString: urlStr, parameters: parameters) { (result, error) in
            
            guard let resultDict = result as? [String : AnyObject] else{
                finished(result: nil, error: error)
                return
            }
//            print(resultDict["statuses"])
            //resultDict["statuses"],取出来的还是AnyObject？ ，所以要转成 [[String : AnyObject]]？
            finished(result: resultDict["statuses"] as? [[String : AnyObject]], error: error)

        }
        
        
    }
}
//MARK:- 发布微博
extension HttpTool {
    func composeStatus(text : String , success : (isSuccess : Bool ,error : NSError?) -> ()) {
        let url = "https://api.weibo.com/2/statuses/update.json"
        
        let parameters = ["access_token" :(OAuthUserTool.shareInstance.account?.access_token)!, "status" : text]
        
        request(.POST, urlString: url, parameters: parameters) { (result, error) in
            print(error)
            if result != nil{
                success(isSuccess: true,error: nil)
            }else{
                success(isSuccess: false ,error: error)
            }
        }
        
        
    }
}
//MARK:- 发布图片微博
extension HttpTool{
    func composePicStatus(text : String ,image : UIImage ,success : (isSuccess : Bool,error : NSError?) -> ()) {
        
        let url = "https://api.weibo.com/2/statuses/upload.json"
        
        let parameters = ["access_token" :(OAuthUserTool.shareInstance.account?.access_token)!, "status" : text]
        
        POST(url, parameters: parameters, constructingBodyWithBlock: { (formData) in
            
            if let imgData = UIImageJPEGRepresentation(image, 0.5){
                formData.appendPartWithFileData(imgData,name : "pic",fileName : "123.png" ,mimeType : "image/png")
                
            }
            }, progress: nil, success: { (_, _) in
                success(isSuccess: true, error: nil)
        }) { (_, error) in
            let data = error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData
            let errorStr = String.init(data: data, encoding: NSUTF8StringEncoding)
            print(errorStr)
            success(isSuccess: false, error: error)
        }
        
        
    }
}