//
//  Configuration.h
//
//  Created by Vlad Tsepelev on 12/30/10.
//  Copyright 2010 __CustomerCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (nonatomic,readonly) NSString * serverUrl;
@property (nonatomic,readonly) NSString * securityToken;
@property (nonatomic,retain) NSMutableArray * favoriteSongsIds; // store favorite songs id


+ (Configuration *) sharedInstance;

+(void) saveSettings;

+(BOOL) isFullVersion;
+(BOOL) isLiteVersion;
+(BOOL) isHDVersion;
+(BOOL) isPhoneVersion;
+(BOOL) checkForUpdatesAtStart;

-(NSString *) FILEPATH_OFFLINE_SONGS_RESPONSE;

@end
