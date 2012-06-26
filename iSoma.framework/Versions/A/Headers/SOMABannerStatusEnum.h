#pragma once
#import <Foundation/Foundation.h>

/**
 * Status of the received banner.
 */
typedef enum {
	/**
	 * The banner download was successfull.
	 */
	kSOMABannerStatusSuccess = 0,
	/**
	 * There was an error during banner download.
	 */
	kSOMABannerStatusError
} SOMABannerStatus;

/**
 * Class to convert the enum values to their corresponding string representations and back.
 */
@interface SOMABannerStatusEnumConverter : NSObject {
}

/**
 * Returns the string for the given enum value or @"" if the value is unset.
 */
+ (NSString *) stringForValue:(SOMABannerStatus) value;
/**
 * Returns the enum value for the given string or the value with cardinality 0 if the string is not found.
 */
+ (SOMABannerStatus) valueForString:(NSString *) string;

@end
// Actifsource ID=[7f71eaaf-a098-11e0-930d-cf00c5c294d3,4e16b021-9e65-11e0-930d-cf00c5c294d3]
