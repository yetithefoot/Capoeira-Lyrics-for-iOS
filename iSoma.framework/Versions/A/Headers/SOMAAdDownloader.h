//
//  AdDownloader.h
//  SOMADemo
//
//  Created by Gerrit Alves on 30.06.11.
//  Copyright 2011 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMAAdDownloaderProtocol.h"

@class SOMAAutoReloadTimer;
@protocol SOMAHttpConnectorProtocol;

@interface SOMAAdDownloader : NSObject<SOMAAdDownloaderProtocol> {
    NSMutableArray* mAdListener;
    id<SOMAHttpConnectorProtocol> mHttpConnector;
    NSString * mUserAgent;
    bool mDownloading;
    SOMAAutoReloadTimer *mReloadTimer;
}

@property (nonatomic, retain) SOMAAdSettings* adSettings;

-(NSString*)requestString;

@end
