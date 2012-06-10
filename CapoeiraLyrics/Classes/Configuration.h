//
//  Configuration.h
//
//  Created by Vlad Tsepelev on 12/30/10.
//  Copyright 2010 __CustomerCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (nonatomic,readonly) NSString * serverUrl;
@property (nonatomic,readonly) NSString * securityToken;

+ (Configuration *) sharedInstance;

@end
