//
//  Configuration.m
//
//  Created by Vlad Tsepelev on 12/30/10.
//  Copyright 2010 __CustomerCompanyName__. All rights reserved.
//

#import "Configuration.h"


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


-(NSString *) FILEPATH_FAVORITE_SONGS_IDS{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"favorite_songs_ids.txt"];
    return foofile;
}
-(id) init{
	
	if((self = [super init]))
	{
		// load favorites array
        /* NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:FILE_FAVORITE_SONGS_IDS];*/
        NSString * filename = [self FILEPATH_FAVORITE_SONGS_IDS];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filename];
        if(fileExists)
            self.favoriteSongsIds = [NSMutableArray arrayWithContentsOfFile:filename];
        else{
            self.favoriteSongsIds = [NSMutableArray array];
            [self.favoriteSongsIds writeToFile:filename atomically:YES];
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
    return @"http://capoeiralyrics.info";
}

-(NSString *)securityToken{
    return @"CC03921EB31B11E18EC38C3C6188709B"; // security tken used on server
}

- (void)dealloc {
    
    [favoriteSongsIds release];
    [super dealloc];
}


@end
