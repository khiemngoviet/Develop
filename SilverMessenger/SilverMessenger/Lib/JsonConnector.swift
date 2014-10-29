//
//  JsonConnector.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
class JsonConnector {
    var delegate:JsonConnectorProtocol!
        
    let connectorManager: AFHTTPRequestOperationManager!
    var token:String!
        
    init(){
        let companyid = GlobalVariable.shareInstance.loginInfo.server
        var url:NSURL = NSURL(string: "http://\(companyid).azurewebsites.net/json")!
        connectorManager = AFHTTPRequestOperationManager(baseURL: url)
        connectorManager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.allZeros)
     }
    
    func authenticate(username:String, pwd:String){
        connectorManager.GET("authenticate/\(username)/\(pwd)",
            parameters: nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    self.token = (responseObject as NSDictionary).objectForKey("AuthenticateResult") as NSString
                    self.delegate.didAuthenticate(true)
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
               self.delegate.didAuthenticate(false)
        })
    }
}