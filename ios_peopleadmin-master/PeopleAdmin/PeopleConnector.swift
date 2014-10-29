//
//  PeopleConnector.swift
//  PeopleAdmin
//
//  Created by Santiago Hurtado on 8/6/14.
//  Copyright (c) 2014 Advance Teknologies. All rights reserved.
//

import Foundation


protocol PeopleConnectorProtocol{
    func didReceiveList(results:NSDictionary)
}

class PeopleConnector{
    
    var delegate:PeopleConnectorProtocol?
    let manager:AFHTTPRequestOperationManager
    
    var token:String?
    
    init()
    {
        var url:NSURL = NSURL(string:"http://silversf.azurewebsites.net/json")!
        manager = AFHTTPRequestOperationManager(baseURL:url)
    }
    
    func authenticate(){
        manager.GET("authenticate/admin/admin",
            parameters:nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    self.token = (responseObject as NSDictionary).objectForKey("AuthenticateResult") as NSString
                    println(responseObject)
                    //self.delegate?.didReceiveList(responseObject as NSDictionary)
                }
                
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    func list(){
        manager.requestSerializer.setValue(self.token!, forHTTPHeaderField: "X-Auth-Token")
        manager.GET("getdata",
            parameters:nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    let str = (responseObject as NSDictionary).objectForKey("GetDataResult") as NSString
                    println(responseObject)
                    //self.delegate?.didReceiveList(responseObject as NSArray)
                }
                
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
}
