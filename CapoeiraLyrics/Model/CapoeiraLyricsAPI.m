//
//  CapoeiraLyricsAPI.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapoeiraLyricsAPI.h"
#import "AFJSONRequestOperation.h"

static CapoeiraLyricsAPI * _instance;

@implementation CapoeiraLyricsAPI

@synthesize delegate;

+ (CapoeiraLyricsAPI *) sharedInstance
{
	if(_instance == nil){
		_instance = [[CapoeiraLyricsAPI alloc] init];
	}
    	return _instance;
}

-(void) getAllSongsFull{
    Configuration * cfg = [Configuration sharedInstance];
    NSString * urlString = [NSString stringWithFormat:@"%@/JSONAPI/AllSongs?token=%@", cfg.serverUrl, cfg.securityToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

            
            
            NSLog(@"http://capoeiralyrics.info/JSONAPI/AllSongs request JSON: %@", JSON );
            
            // parse songs from JSON to model objects
            NSMutableArray * retVal = [NSMutableArray array];
            
            for (id jsonSong in JSON) {
                Song * song = [Song songWithDictionary:jsonSong];
                [retVal addObject:song];
            }
            
            if([self.delegate respondsToSelector:@selector(songsDidLoad:)]){
                [self.delegate performSelector:@selector(songsDidLoad:) withObject:retVal];
            }
            
        }
        failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            if([self.delegate respondsToSelector:@selector(didFail)]){
                [self.delegate performSelector:@selector(didFail)];
            }
        }];
    
    [operation start];
}

-(void) getSong: (int) songId{
    Configuration * cfg = [Configuration sharedInstance];
    NSString * urlString = [NSString stringWithFormat:@"%@/JSONAPI/Song/%d?token=%@", cfg.serverUrl, songId, cfg.securityToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSLog(@"http://capoeiralyrics.info/JSONAPI/Song request JSON: %@", JSON );
            
            Song * song = [Song songWithDictionary:JSON];
            
            if([self.delegate respondsToSelector:@selector(songDidLoad:)]){
                [self.delegate performSelector:@selector(songDidLoad:) withObject:song];
            }
            
        }
        failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            if([self.delegate respondsToSelector:@selector(didFail)]){
                [self.delegate performSelector:@selector(didFail)];
            }
        }];
    
    [operation start];
}


@end
