//
//  NoteConnector.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
class NoteConnector: JsonConnector {
    
    
    func getPolicies(){
        connectorManager.requestSerializer.setValue(self.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.GET("getpolicies",
            parameters: nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    let policiesArr = (responseObject as NSDictionary).objectForKey("GetPoliciesResult") as NSArray
                    (self.delegate as NoteConnectorProtocol).didReceivePolicies!(policiesArr)
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    func getBusinessEntities(){
        connectorManager.requestSerializer.setValue(self.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.GET("getbusinessentities",
            parameters: nil,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    let businessArr = (responseObject as NSDictionary).objectForKey("GetBusinessEntitiesResult") as NSArray
                    (self.delegate as NoteConnectorProtocol).didReceiveBusinessEntities!((businessArr))
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    func SaveNotes(saveToNotes: NSDictionary){
        connectorManager.requestSerializer.setValue(self.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.GET("SaveNotes",
            parameters: saveToNotes,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                if responseObject.isKindOfClass(NSDictionary)
                {
                    println("JSON:" + responseObject.description)
                }
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
        })
    }
    
    
    //    [DataContract]
    //    public class SaveToNote
    //    {
    //        [DataMember]
    //        public string Username { get; set; }
    //
    //        [DataMember]
    //        public bool IsPolicy { get; set; }
    //
    //        [DataMember]
    //        public bool IsEntity { get; set; }
    //
    //        [DataMember]
    //        public string PolicyCode { get; set; }
    //
    //        [DataMember]
    //        public string BusinessCode { get; set; }
    //
    //        [DataMember]
    //        public string Subject { get; set; }
    //
    //        [DataMember]
    //        public string Content { get; set; }
    //    }
    
}