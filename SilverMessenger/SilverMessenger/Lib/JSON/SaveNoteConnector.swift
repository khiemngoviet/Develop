//
//  SaveNoteConnector.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 11/1/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
class SaveNoteConnector: JsonConnector {
    
    func SaveNotes(saveToNotes: NSDictionary){
        connectorManager.requestSerializer.setValue(GlobalVariable.shareInstance.token, forHTTPHeaderField: "X-Auth-Token")
        connectorManager.POST("SaveNotes",
            parameters: saveToNotes,
            success:{(operation:AFHTTPRequestOperation!,responseObject:AnyObject!)in
                (self.delegate as SaveNoteConnectorDelegate).didPostNote!(true)
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!)in
                println("Error:"+error.localizedDescription)
                (self.delegate as SaveNoteConnectorDelegate).didPostNote!(false)
        })
    }
    
}