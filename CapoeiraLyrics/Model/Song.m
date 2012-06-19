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
#warning if nil set empty strings
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

-(BOOL)isFavorite{
    // load file with favorites to dictionary
    // check song is favorite
    NSNumber * boxed_identifier = [NSNumber numberWithInt:self.identifier];
    return [[Configuration sharedInstance].favoriteSongsIds containsObject:boxed_identifier];
}

-(void)setFavorite:(BOOL)aFavorite{
    // load file with favorites into dictionary
    // add song to favorites
    NSNumber * boxed_identifier = [NSNumber numberWithInt:self.identifier];
    if(![[Configuration sharedInstance].favoriteSongsIds containsObject:boxed_identifier] && aFavorite){
        [[Configuration sharedInstance].favoriteSongsIds addObject:boxed_identifier];
    }else if([[Configuration sharedInstance].favoriteSongsIds containsObject:boxed_identifier] && !aFavorite){
        [[Configuration sharedInstance].favoriteSongsIds removeObject:boxed_identifier];
    }
}

+(NSArray *)filterOnlyFavorites:(NSArray *)aSongs{
    
    if(!aSongs) return nil;
    
    NSMutableArray * retArr = [NSMutableArray array];
    
    for (Song * aSong in aSongs) {
        NSNumber * boxed_id = [NSNumber numberWithInt:aSong.identifier];
        if([[Configuration sharedInstance].favoriteSongsIds containsObject:boxed_id]){
            [retArr addObject:aSong];  
        }
    }
    
    return retArr;
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
