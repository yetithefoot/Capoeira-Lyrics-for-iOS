//
//  CapoeiraLyricsAPI.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapoeiraLyricsAPI.h"
#import "AFJSONRequestOperation.h"
#import "AFJSONUtilities.h"
#import "JSONKit.h"


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

            
            if(JSON){
                // replace temp offline response file
                NSString* path = [[Configuration sharedInstance] FILEPATH_OFFLINE_SONGS_RESPONSE];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:path error:NULL];
                
                NSData * raw = AFJSONEncode(JSON, NULL);
                [raw writeToFile:path atomically:NO];
                
                //NSLog(@"http://capoeiralyrics.info/JSONAPI/AllSongs request JSON: %@", JSON );
                
                // parse songs from JSON to model objects
                NSMutableArray * retVal = [NSMutableArray array];
                
                for (id jsonSong in JSON) {
                    Song * song = [Song songWithDictionary:jsonSong];
                    [retVal addObject:song];
                }
                
                if([self.delegate respondsToSelector:@selector(getAllSongsFullDidLoad:)]){
                    [self.delegate performSelector:@selector(getAllSongsFullDidLoad:) withObject:retVal];
                }
            }else {
                if([self.delegate respondsToSelector:@selector(getSongsCountDidFail)]){
                    [self.delegate performSelector:@selector(getSongsCountDidFail)];
                }
            }
            
        }
        failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            if([self.delegate respondsToSelector:@selector(getAllSongsFullDidFail)]){
                [self.delegate performSelector:@selector(getAllSongsFullDidFail)];
            }
        }];
    
    [operation start];
}



-(void) getAllSongsFullFromLocalStorage{

    NSString* path = [[Configuration sharedInstance] FILEPATH_OFFLINE_SONGS_RESPONSE];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    id JSON = nil;
    if (data && [data length] > 0) {
        NSError *error = nil;
            
        JSON = AFJSONDecode(data, &error);
    }
    
    //NSLog(@"!!!LOCAL STORAGE AllSongs request JSON: %@", JSON );
    
    // parse songs from JSON to model objects
    NSMutableArray * retVal = [NSMutableArray array];
    
    for (id jsonSong in JSON) {
        Song * song = [[Song alloc]initWithDictionary:jsonSong];
        [retVal addObject:song];
        [song release];
    }
    
    if([self.delegate respondsToSelector:@selector(getAllSongsFullDidLoad:)]){
        [self.delegate performSelector:@selector(getAllSongsFullDidLoad:) withObject:retVal];
    }
    
}

/*
-(void) getSong: (int) songId{
    Configuration * cfg = [Configuration sharedInstance];
    NSString * urlString = [NSString stringWithFormat:@"%@/JSONAPI/Song/%d?token=%@", cfg.serverUrl, songId, cfg.securityToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            //NSLog(@"http://capoeiralyrics.info/JSONAPI/Song request JSON: %@", JSON );
            
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
 */

-(void) getSongsCount{
    Configuration * cfg = [Configuration sharedInstance];
    NSString * urlString = [NSString stringWithFormat:@"%@/JSONAPI/SongsCount?token=%@", cfg.serverUrl, cfg.securityToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            //NSLog(@"http://capoeiralyrics.info/JSONAPI/Songount request JSON: %@", JSON );
            
            if(JSON && [JSON count] > 0){
                int count = [[[JSON allObjects]objectAtIndex:0] intValue];
            
                if([self.delegate respondsToSelector:@selector(getSongsCountDidLoad:)]){
                    [self.delegate performSelector:@selector(getSongsCountDidLoad:) withObject:[NSNumber numberWithInt:count]];
                }
            }else {
                if([self.delegate respondsToSelector:@selector(getSongsCountDidFail)]){
                    [self.delegate performSelector:@selector(getSongsCountDidFail)];
                }
            }
            
        }
        failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            if([self.delegate respondsToSelector:@selector(getSongsCountDidFail)]){
                [self.delegate performSelector:@selector(getSongsCountDidFail)];
            }
        }];
    
    [operation start];
}


@end
