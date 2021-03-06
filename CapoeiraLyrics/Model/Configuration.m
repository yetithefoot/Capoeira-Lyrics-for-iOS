//
//  Configuration.m
//
//  Created by Vlad Tsepelev on 12/30/10.
//  Copyright 2010 __CustomerCompanyName__. All rights reserved.
//

#import "Configuration.h"
#import "PrivateConstants.h"

#import <sys/xattr.h>

static Configuration* _instance;

@implementation Configuration

@synthesize serverUrl;
@synthesize securityToken;
@synthesize favoriteSongsIds;



+ (Configuration*) sharedInstance
{
	if(_instance == nil){
		_instance = [[Configuration alloc] init];
	}
   
	return _instance;
}

+(BOOL) isFullVersion{
#ifdef FULL_VERSION
    return YES;
#else
    return NO;
#endif  
}


+(BOOL) isLiteVersion{
#ifdef LITE_VERSION
    return YES;
#else
    return NO;
#endif      
}

+(BOOL) isHDVersion{
#ifdef HD_VERSION
    return YES;
#else
    return NO;
#endif      
}

+(BOOL) isPhoneVersion{
    return ![Configuration isHDVersion];
}





+ (void) addSkipBackupAttributeToPath: (NSString*) path {
    NSURL* url = [[NSURL alloc] initFileURLWithPath: path];

    if(&NSURLIsExcludedFromBackupKey != nil){
        NSError *error = nil;
        
        BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
        }
    } else {
        const char* filePath = [[url path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    }
}



-(NSString *) FILEPATH_FAVORITE_SONGS_IDS{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"favorite_songs_ids.txt"];
    return foofile;
}

-(NSString *) FILEPATH_OFFLINE_SONGS_RESPONSE{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"GetAllSongsFull.json"];
    return foofile;
}

-(id) init{
	
	if((self = [super init]))
	{
		// load favorites array
        NSString * filename = [self FILEPATH_FAVORITE_SONGS_IDS];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filename];
        if(fileExists)
            self.favoriteSongsIds = [NSMutableArray arrayWithContentsOfFile:filename];
        else{
            self.favoriteSongsIds = [NSMutableArray array];
            [self.favoriteSongsIds writeToFile:filename atomically:YES];
            [Configuration addSkipBackupAttributeToPath:filename]; // set NO SYNC WITH iCLOUD attribute
        }
        
        // copy offline response stub
        NSError *error;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"GetAllSongsFull" ofType:@"json"];
        fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self FILEPATH_OFFLINE_SONGS_RESPONSE]];
        if(!fileExists){
            if([[NSFileManager defaultManager] copyItemAtPath:path toPath:[self FILEPATH_OFFLINE_SONGS_RESPONSE] error:&error]){
                NSLog(@"File successfully copied");
            } else {
                NSLog(@"Error description-%@ \n", [error localizedDescription]);
                NSLog(@"Error reason-%@", [error localizedFailureReason]);
            }
        }
        
	}
	return self;
	
}







+ (NSString*) getStringValueFromSetting: (NSString *)key
{
	NSString* tmp =[[NSUserDefaults standardUserDefaults] stringForKey:key];  
	if(tmp == nil)
		[self registerDefaultsFromSettingsBundle];
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];  
}

+ (int) getIntValueFromSetting: (NSString *)key
{
	NSString* tmp =[[NSUserDefaults standardUserDefaults] stringForKey:key];  
	if(tmp == nil)
		[self registerDefaultsFromSettingsBundle];
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];  
}

+ (int) getBoolValueFromSetting: (NSString *)key
{
	NSString* tmp =[[NSUserDefaults standardUserDefaults] stringForKey:key];  
	if(tmp == nil)
		[self registerDefaultsFromSettingsBundle];
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];  
}

+(BOOL) checkForUpdatesAtStart{
    return [Configuration getBoolValueFromSetting:@"check_for_updates_at_start"];
}


+ (void)registerDefaultsFromSettingsBundle 
{ 
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]; 
	if(!settingsBundle) 
	{ 
		return; 
	} 
	
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]]; 
	NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"]; 
	
	NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]]; 
	for(NSDictionary *prefSpecification in preferences) 
	{ 
		NSString *key = [prefSpecification objectForKey:@"Key"]; 
		if(key) 
		{ 
			[defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key]; 
		} 
	} 
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister]; 
	[defaultsToRegister release]; 
}

+(void)saveSettings
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // save favorite songs ids
    [[Configuration sharedInstance].favoriteSongsIds writeToFile:[[Configuration sharedInstance] FILEPATH_FAVORITE_SONGS_IDS] atomically:YES];
    
	// save user settings here
	[prefs synchronize];
}


-(NSString *)serverUrl{
    return [PrivateConstants serverUrl];
}

-(NSString *)securityToken{
    return [PrivateConstants securityToken];
}

- (void)dealloc {
    
    [favoriteSongsIds release];
    [super dealloc];
}


@end
