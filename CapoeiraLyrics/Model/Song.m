//
//  Song.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Song.h"

@implementation Song


@synthesize identifier, name, text, artist, translation, audioUrl, videoUrl;

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
            
            id translationObj = [dict objectForKey:@"Translate"];
            if(translationObj && ((CFNullRef)translationObj != kCFNull) && (![translationObj isEqualToString:@""]))
                self.translation = translationObj;
            
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
    [self.audioUrl release];
    [self.videoUrl release];
    [super dealloc];
}

@end
