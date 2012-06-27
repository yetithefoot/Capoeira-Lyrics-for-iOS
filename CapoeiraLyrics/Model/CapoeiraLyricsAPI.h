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
-(void) getAllSongsFullDidLoad:(NSArray *)songs;
-(void) getSongsCountDidLoad:(NSNumber *) count;
-(void) getAllSongsFullDidFail;
-(void) getSongsCountDidFail;
@end

@interface CapoeiraLyricsAPI : NSObject{
    
}

@property (nonatomic, assign) id<CapoeiraLyricsAPIDelegate> delegate;

+ (CapoeiraLyricsAPI *) sharedInstance;

-(void) getAllSongsFull;
-(void) getAllSongsFullFromLocalStorage;
-(void) getSongsCount;

@end
