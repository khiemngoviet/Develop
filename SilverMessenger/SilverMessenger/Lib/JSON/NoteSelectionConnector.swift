//
//  NoteConnector.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
class NoteSelectionConnector: JsonConnector {
    func getPolicies(){
        connectorManager.requestSerializer.setValue(GlobalVariable.shareInstance.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.GET("getpolicies",
            parameters: nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    let policiesArr = (responseObject as NSDictionary).objectForKey("GetPoliciesResult") as NSArray
                    (self.delegate as NoteSelectionConnectorDelegate).didReceivePolicies!(policiesArr)
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    func getBusinessEntities(){
        connectorManager.requestSerializer.setValue(GlobalVariable.shareInstance.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.GET("getbusinessentities",
            parameters: nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    let businessArr = (responseObject as NSDictionary).objectForKey("GetBusinessEntitiesResult") as NSArray
                    (self.delegate as NoteSelectionConnectorDelegate).didReceiveBusinessEntities!((businessArr))
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    
    
}