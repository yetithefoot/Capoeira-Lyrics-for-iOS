//
//  SOMAGlobalSettings.h
//  iSoma
//
//  Created by Gerrit Alves on 28.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMAUserSettings.h"

typedef enum {
	kSOMALoglevelNone = 0,
    kSOMALoglevelError = 1,
	kSOMALoglevelWarning = 2,
    kSOMALoglevelInfo = 3,
    kSOMALoglevelDebug = 4
} SOMALogLevel;

@interface SOMAGlobalSettings : NSObject {
}

@property (nonatomic, retain) SOMAUserSettings* userSettings;
@property (nonatomic) SOMALogLevel logLevel;

+(SOMAGlobalSettings*)globalSettings;

@end
