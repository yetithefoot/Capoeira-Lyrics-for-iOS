//
//  Tag.m
//  todotogo
//
//  Created by Vlad Tsepelev on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize name = _name, identifier = _identifier;


-(id) initWithIdentifier: (NSString *)identifier andName: (NSString *) name{
    if(self = [super init]){
        self.name = name;
        self.identifier = identifier;
    }
    
    return self;
}

+(id) tagWithIdentifier: (NSString *)identifier andName: (NSString *) name{
    return [[[Tag alloc] initWithIdentifier:identifier andName:name] autorelease];
}

-(NSString *)description{
    return self.name;
}

- (id)proxyForJson {
	return self.identifier;
}


-(void)dealloc{
    [_name release];
    [_identifier release];
    [super dealloc];
}

@end
