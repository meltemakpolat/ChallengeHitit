//
//  BaseNetworkManager.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import Alamofire

class BaseNetworkManager: NSObject {

    class func get(url: String, parameters: [String : Any]?, headers:[String : String]?, success:@escaping (_ response:Data?) -> Void, failure:@escaping (_ error:Error , _ statusCode:Int) -> Void ) -> Void {
        
        Alamofire.request(url, method:.get, parameters:parameters, encoding:URLEncoding.queryString, headers:headers).validate().responseJSON{ response in
            
            switch response.result {
                
            case .success( _):
                success(response.data)
                
            case .failure(let error):
                let statusCode : Int = response.response?.statusCode ?? 0
                failure(error, statusCode)
            }
        }
    }
    
    class func post(url: String, parameters: [String : Any]?, headers:[String : String]?, success:@escaping (_ response:Data?) -> Void, failure:@escaping (_ error:Error , _ statusCode:Int) -> Void ) -> Void {
        
        
        Alamofire.request(url, method:.post, parameters:parameters, encoding:JSONEncoding.default, headers:headers).validate().responseJSON{ response in
            
            switch response.result {
                
            case .success( _):
                success(response.data)
                
            case .failure(let error):
                let statusCode : Int = response.response?.statusCode ?? 0
                failure(error, statusCode)
            }
            
        }
    }
}


