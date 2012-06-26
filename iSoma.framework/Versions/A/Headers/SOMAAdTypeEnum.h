#pragma once
#import <Foundation/Foundation.h>

/**
 * All possible values of banner types.
 */
typedef enum {
	/**
	 * Requests a banner of any type (except video).
	 */
	kSOMAAdTypeAll = 0,
	/**
	 * Request an image banner.
	 */
	kSOMAAdTypeImage,
	/**
	 * Requests a text banner.
	 */
	kSOMAAdTypeText,
	/**
	 * Requests a video banner.
	 */
	kSOMAAdTypeVideo,
	/**
	 * Requests a rich media banner.
	 */
	kSOMAAdTypeRichMedia
} SOMAAdType;

/**
 * Class to convert the enum values to their corresponding string representations and back.
 */
@interface SOMAAdTypeEnumConverter : NSObject {
}

/**
 * Returns the string for the given enum value or @"" if the value is unset.
 */
+ (NSString *) stringForValue:(SOMAAdType) value;
/**
 * Returns the enum value for the given string or the value with cardinality 0 if the string is not found.
 */
+ (SOMAAdType) valueForString:(NSString *) string;

@end
// Actifsource ID=[7f71eaaf-a098-11e0-930d-cf00c5c294d3,1a2ec49a-9d97-11e0-930d-cf00c5c294d3]
