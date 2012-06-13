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
    NSString * urlString = [NSString stringWithFormat:@"%@/JSONAPI/AllSongsFull?token=%@", cfg.serverUrl, cfg.securityToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

            NSLog(@"http://capoeiralyrics.info/JSONAPI/AllSongsFull request JSON: %@", JSON );
            
            if([self.delegate respondsToSelector:@selector(songsDidLoad:)]){
                [self.delegate performSelector:@selector(songsDidLoad:) withObject:JSON];
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
    
}


@end
