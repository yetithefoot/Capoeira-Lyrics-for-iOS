//
//  Song.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, assign) long identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *translation;

-(id) initWithDictionary: (NSDictionary *) dict;
+(id) songWithDictionary: (NSDictionary *) dict;

@end