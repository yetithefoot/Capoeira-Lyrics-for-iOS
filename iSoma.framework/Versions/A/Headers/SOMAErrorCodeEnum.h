#pragma once
#import <Foundation/Foundation.h>

/**
 * All possible errors that can occur during the banner request.
 */
typedef enum {
	/**
	 * No error.
	 */
	kSOMAErrorCodeNoError = 0,
	/**
	 * The publisher or adspace id is invalid.
	 */
	kSOMAErrorCodeUnknownPublisherOrAdspaceId,
	/**
	 * The system is unable to connect to the smaato server.
	 */
	kSOMAErrorCodeNoConnectionError,
	/**
	 * Currently no ad available.
	 */
	kSOMAErrorCodeNoAdAvailable,
	/**
	 * Please inspect error message for further details.
	 */
	kSOMAErrorCodeGeneralError,
	/**
	 * Error during response parsing.
	 */
	kSOMAErrorCodeParsingError
} SOMAErrorCode;

/**
 * Class to convert the enum values to their corresponding string representations and back.
 */
@interface SOMAErrorCodeEnumConverter : NSObject {
}

/**
 * Returns the string for the given enum value or @"" if the value is unset.
 */
+ (NSString *) stringForValue:(SOMAErrorCode) value;
/**
 * Returns the enum value for the given string or the value with cardinality 0 if the string is not found.
 */
+ (SOMAErrorCode) valueForString:(NSString *) string;

@end
// Actifsource ID=[7f71eaaf-a098-11e0-930d-cf00c5c294d3,ba3daa18-a16f-11e0-930d-cf00c5c294d3]
