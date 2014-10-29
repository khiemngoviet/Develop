//
//  PeopleConnector.swift
//  PeopleAdmin
//
//  Created by Santiago Hurtado on 8/9/14.
//  Copyright (c) 2014 Advance Teknologies. All rights reserved.
//

import Foundation

protocol PersonConnectorProtocol{
    func didReceivePersonDetail(person:NSDictionary)
}

class PersonConnector{
    var delegate:PeopleConnectorProtocol?
    
    let manager:AFHTTPRequestOperationManager!
    
    init()
    {
        var url:NSURL = NSURL(string:"http://silversf.azurewebsites.net/json")!
        manager = AFHTTPRequestOperationManager(baseURL: url)
        manager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.allZeros)
    }
    func detail(id:NSInteger){
        manager.GET("/getdata/", parameters: nil,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) in
                println("JSON:"+response.description)
            },failure: { (operation:AFHTTPRequestOperation!, error:NSError!) in
                println("ERROR"+error.localizedDescription)
        })
        
    }
    func create(person:NSDictionary){
        manager.POST("", parameters: person, success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
            println("JSON:"+response.description)
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!) in
                println("ERROR:"+error.localizedDescription)
        })
    }
    func update(person:NSDictionary){
        manager.PUT("", parameters: person,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) in
                println("JSON:"+response.description)
            },failure: { (operation:AFHTTPRequestOperation!, error:NSError!) in
                println("ERROR"+error.localizedDescription)
        })
        
    }
    func delete(id:Int){
        manager.DELETE("/\(id)", parameters: nil,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) in
                println("JSON:"+response.description)
            },failure: { (operation:AFHTTPRequestOperation!, error:NSError!) in
                println("ERROR"+error.localizedDescription)
        })
    }
}