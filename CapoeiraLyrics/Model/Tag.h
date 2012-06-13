//
//  Tag.h
//  todotogo
//
//  Created by Vlad Tsepelev on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject{
    NSString * _identifier;
    NSString * _name;
}

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;

-(id) initWithIdentifier: (NSString *)identifier andName: (NSString *) name;
+(id) tagWithIdentifier: (NSString *)identifier andName: (NSString *) name;

@end
