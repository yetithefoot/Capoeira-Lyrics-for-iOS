//
//  CapoeiraLyricsAPI.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Song.h"

@protocol CapoeiraLyricsAPIDelegate <NSObject>
@optional
-(void) songsDidLoad:(NSArray *)songs;
-(void) songDidLoad:(Song *) song;
-(void) songsCountDidLoad:(NSNumber *) count;
-(void) didFail;
@end

@interface CapoeiraLyricsAPI : NSObject{
    
}

@property (nonatomic, assign) id<CapoeiraLyricsAPIDelegate> delegate;

+ (CapoeiraLyricsAPI *) sharedInstance;

-(void) getAllSongsFull;
-(void) getAllSongsFullFromLocalStorage;
-(void) getSong: (int) songId;
-(void) getSongsCount;

@end
