//
//  LoginInfo.swift
//  SilverMessenger
//
//  Created by Tran Ngoc Hieu on 10/4/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

class LoginInfo {
    var server: String?
    var userName: String?
    
    init(){
        
    }
    
    init(server:String, userName:String){
        self.server = server
        self.userName = userName
    }
    
    func clearInfo(){
        self.server = nil
        self.userName = nil
    }
}



