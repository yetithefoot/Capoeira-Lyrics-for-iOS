#pragma once

// Begin Protected Region [[000dfe72-9d7b-11e0-930d-cf00c5c294d3,imports]]
#import <Foundation/Foundation.h>
// End Protected Region   [[000dfe72-9d7b-11e0-930d-cf00c5c294d3,imports]]

typedef enum {
	kSOMAGenderUnset,
	kSOMAGenderMale,
	kSOMAGenderFemale
} SOMAGender;

@interface SOMAGenderEnumConverter : NSObject {
}
+(NSString*)stringForValue:(SOMAGender) value;
@end

@interface SOMAUserSettings : NSObject {
}

/**
 * Targeting parameter for UserGender.
 */
@property (nonatomic) SOMAGender userGender;
/**
 * Targeting parameter for Age.
 */
@property (nonatomic) int age;
/**
 * Targeting parameter for KeywordList.
 */
@property (nonatomic,copy) NSString * keywordList;
/**
 * Targeting parameter for SearchQuery.
 */
@property (nonatomic,copy) NSString * searchQuery;
/**
 * Targeting parameter for Region.
 */
@property (nonatomic,copy) NSString * region;
/**
 * Targeting parameter for Country.
 */
@property (nonatomic,copy) NSString * country;
/**
 * Targeting parameter for City.
 */
@property (nonatomic,copy) NSString * city;
/**
 * Targeting parameter for Zip.
 */
@property (nonatomic,copy) NSString * zip;
/**
 * Targeting parameter for Latitude.
 */
@property (nonatomic) double latitude;
/**
 * Targeting parameter for Longitude.
 */
@property (nonatomic) double longitude;
/**
 * Targeting parameter for userProfileEnabled.
 */
@property (nonatomic) bool  userProfileEnabled;

/**
 * Returns the request string that is sent to the soma server.
 */
-(NSString*)requestString;
@end

// Actifsource ID=[b8fd4eee-9d83-11e0-930d-cf00c5c294d3,000dfe72-9d7b-11e0-930d-cf00c5c294d3]
