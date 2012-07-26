//
//  Song.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Song.h"

@implementation Song


@synthesize identifier, name, text, artist, engtext, rustext, audioUrl, videoUrl;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        if(dict){
            id identifierObj = [dict objectForKey:@"ID"];
            if(identifierObj && ((CFNullRef)identifierObj != kCFNull))
                self.identifier = [identifierObj longValue];
            
            id nameObj = [dict objectForKey:@"Name"];
            if(nameObj && ((CFNullRef)nameObj != kCFNull) && (![nameObj isEqualToString:@""]))
                self.name = nameObj;
            
            id textObj = [dict objectForKey:@"Text"];
            if(textObj && ((CFNullRef)textObj != kCFNull) && (![textObj isEqualToString:@""]))
                self.text = textObj;
            
            id artistObj = [dict objectForKey:@"Artist"];
            if(artistObj && ((CFNullRef)artistObj != kCFNull) && (![artistObj isEqualToString:@""]))
                self.artist = artistObj;
            
            id engtextObj = [dict objectForKey:@"EngText"];
            if(engtextObj && ((CFNullRef)engtextObj != kCFNull) && (![engtextObj isEqualToString:@""]))
                self.engtext = engtextObj;
            
            id rustextObj = [dict objectForKey:@"RusText"];
            if(rustextObj && ((CFNullRef)rustextObj != kCFNull) && (![rustextObj isEqualToString:@""]))
                self.rustext = rustextObj;
            
            id audioUrlObj = [dict objectForKey:@"AudioUrl"];
            if(audioUrlObj && ((CFNullRef)audioUrlObj != kCFNull) && (![audioUrlObj isEqualToString:@""]))
                self.audioUrl = audioUrlObj;
            
            id videoUrlObj = [dict objectForKey:@"VideoUrl"];
            if(videoUrlObj && ((CFNullRef)videoUrlObj != kCFNull) && (![videoUrlObj isEqualToString:@""]))
                self.videoUrl = videoUrlObj;
        }

    }
    return self;
}

+(id) songWithDictionary: (NSDictionary *) dict{
    return [[[Song alloc] initWithDictionary:dict] autorelease];
}

+(Song *)fakeSong{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithLong: 1234567], @"ID",@"",  @"Name",  @"",  @"Text", @"", @"Artist", nil];
    return [[[Song alloc]initWithDictionary:dict]autorelease];
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

+(Song *)getSongByIdentifier:(int) songIdentifier inArray:(NSArray *) songsArray{
    // find index of song clicked by id stored into tag
    NSUInteger found = [songsArray indexOfObjectPassingTest:^(id element, NSUInteger idx, BOOL * stop){
        
        Song * song = (Song*)element;
        
        *stop = (song.identifier == songIdentifier);
        return *stop;
    }];
    
    if (found != NSNotFound){
        return [songsArray objectAtIndex:found];
    }
    
    return nil;
}


-(void) openVideo{
    if(self.videoUrl){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.videoUrl]];
    }
}



- (void)dealloc
{
    [self.name release];
    [self.text release];
    [self.artist release];
    [self.engtext release];
    [self.rustext release];
    [self.audioUrl release];
    [self.videoUrl release];
    [super dealloc];
}

@end
