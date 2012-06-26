#pragma once

#import <Foundation/Foundation.h>
#import "SOMABannerStatusEnum.h"
#import "SOMAAdTypeEnum.h"
#import "SOMAErrorCodeEnum.h"

/**
 * Describes all properties of the received banner.
 */
@protocol SOMAReceivedBannerProtocol <NSObject>
@required
/**
 * The status of the received banner.
 */
-(SOMABannerStatus) status;
/**
 * The html snippet describing the received rich media banner.
 */
-(NSString *) richMediaData;
/**
 * The list of beacons for this banner.
 */
-(NSMutableArray *) beacons;
/**
 * The url to the received video banner.
 */
-(NSString *) mediaFile;
/**
 * The text of the received text banner.
 */
-(NSString *) adText;
/**
 * The url to the received image banner.
 */
-(NSString *) imageUrl;
/**
 * The error code of the received banner.
 */
-(SOMAErrorCode) errorCode;
/**
 * The error message of the received banner.
 */
-(NSString *) errorMessage;
/**
 * The type of the received banner.
 */
-(SOMAAdType) adType;
/**
 * The url to the landing page.
 */
-(NSString *) clickUrl;
@end

// Actifsource ID=[98444d19-a09c-11e0-930d-cf00c5c294d3,d49ad80c-9d8a-11e0-930d-cf00c5c294d3]
