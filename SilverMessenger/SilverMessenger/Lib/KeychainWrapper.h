//
//  KeychainUserPass.h
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/10/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end