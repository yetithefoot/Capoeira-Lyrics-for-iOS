#pragma once
#import <Foundation/Foundation.h>

typedef enum {
	kSOMAAdDimensionDefault = 0,
	/**
	 * Requests a medium ractangle banner.
	 */
	kSOMAAdDimensionMediumRectangle,
	/**
	 * Requests a leaderboard banner. Only available on tablets.
	 */
	kSOMAAdDimensionLeaderboard,
	/**
	 * Requests a skyscraper banner. Only available on tablets.
	 */
	kSOMAAdDimensionSkyscraper
} SOMAAdDimension;

/**
 * Class to convert the enum values to their corresponding string representations and back.
 */
@interface SOMAAdDimensionEnumConverter : NSObject {
}

/**
 * Returns the string for the given enum value or @"" if the value is unset.
 */
+ (NSString *) stringForValue:(SOMAAdDimension) value;
/**
 * Returns the enum value for the given string or the value with cardinality 0 if the string is not found.
 */
+ (SOMAAdDimension) valueForString:(NSString *) string;

@end
// Actifsource ID=[7f71eaaf-a098-11e0-930d-cf00c5c294d3,2e601c03-b2b5-11e0-8511-79e42e6b380a]
