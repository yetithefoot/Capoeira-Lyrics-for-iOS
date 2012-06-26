#pragma once

// Begin Protected Region [[567fd83c-a0ad-11e0-930d-cf00c5c294d3,imports]]
#import "SOMAAdTypeEnum.h"
#import "SOMAAdDimensionEnum.h"
// End Protected Region   [[567fd83c-a0ad-11e0-930d-cf00c5c294d3,imports]]



@interface SOMAAdSettings : NSObject {
}

/**
 * Targeting parameter for PublisherId.
 */
@property (nonatomic) int publisherId;
/**
 * Targeting parameter for AdspaceId.
 */
@property (nonatomic) int adspaceId;
/**
 * Targeting parameter for AdType.
 */
@property (nonatomic) SOMAAdType adType;
/**
 * Targeting parameter for AdDimension.
 */
@property (nonatomic) SOMAAdDimension adDimension;
/**
 * Targeting parameter for bannerWidth.
 */
@property (nonatomic) int bannerWidth;
/**
 * Targeting parameter for bannerHeight.
 */
@property (nonatomic) int bannerHeight;

/**
 * Returns the request string that is sent to the soma server.
 */
-(NSString*)requestString;
@end

// Actifsource ID=[b8fd4eee-9d83-11e0-930d-cf00c5c294d3,567fd83c-a0ad-11e0-930d-cf00c5c294d3]
