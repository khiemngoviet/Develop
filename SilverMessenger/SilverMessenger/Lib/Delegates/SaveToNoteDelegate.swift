//
//  SaveToNoteDelegate.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/31/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
protocol SaveToNoteDelegate{
    func onSelectedCode(noteType:String, code:String, description:String);
}