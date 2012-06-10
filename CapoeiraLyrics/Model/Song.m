//
//  Song.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize identifier, name, text, artist, translation;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
#warning check for keys available
        self.identifier = [[dict objectForKey:@"ID"] longValue];
        self.name = [dict objectForKey:@"Name"];
        self.text = [dict objectForKey:@"Text"];
        self.artist = [dict objectForKey:@"Artist"];
        self.translation = [dict objectForKey:@"Translation"];
        
    }
    return self;
}

+(id) songWithDictionary: (NSDictionary *) dict{
    return [[[Song alloc] initWithDictionary:dict] autorelease];
}

- (void)dealloc
{
    [self.name release];
    [self.text release];
    [self.artist release];
    [self.translation release];
    [super dealloc];
}

@end
