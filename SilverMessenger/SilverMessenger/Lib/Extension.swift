//
//  Extension.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/20/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
extension Array{
    
    func containContact(contactArr: [Contact],key:String) -> Bool{
        let filtered = contactArr.filter {
            return $0.name == key
        }
        return filtered.count > 0
    }
    
    func getContactByKey(contactArr: [Contact],key:String) -> Contact?{
        let filtered = contactArr.filter {
            return $0.name == key
        }
        return filtered.first
    }
    
    func indexOfContact(contactArr: [Contact],key:String) -> Int{
        var index:Int = 0
        for contact in contactArr {
            if contact.name == key{
                break
            }
            index++
        }
        return index
    }
    
}