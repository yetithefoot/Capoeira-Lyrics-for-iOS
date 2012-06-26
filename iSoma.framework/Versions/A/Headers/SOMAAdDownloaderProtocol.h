#pragma once

// Begin Protected Region [[d8fa047c-a164-11e0-930d-cf00c5c294d3,imports]]
#import "SOMAAdListenerProtocol.h"
#import "SOMAAdSettings.h"
#import "SOMAUserSettings.h"
// End Protected Region   [[d8fa047c-a164-11e0-930d-cf00c5c294d3,imports]]

/**
 * ©2011 Smaato, Inc. All Rights Reserved. Use of this software is subject to
 * the Smaato Terms of Service.
 */ 
@protocol SOMAAdDownloaderProtocol <NSObject>
/**
 * Constructor
 */
-(id)init;
/**
 * Remove an ad listener. The listener will no longer receive updates on ad status.
 */
-(void)addAdListener:(id<SOMAAdListenerProtocol>)adListener;
/**
 * Add an ad listener. The listener will receive updates on ad status for this ad space.
 */
-(void)removeAdListener:(id<SOMAAdListenerProtocol>)adListener;
/**
 * Asynchronously loads a new banner. Calls all ad listeners on success or failure.
 */
-(void)asyncLoadNewBanner;
/**
 * Enables or disables the automatic location updates. If enabled the location is updated every 60 seconds. Default is disabled.
 */
-(void)setLocationUpdateEnabled:(bool)updateEnabled;
/**
 * Returns whether the automatic location update is enabled.
 */
-(bool)isLocationUpdateEnabled;
/**
 * Returns the value of property AdSettings.
 */
-(SOMAAdSettings*)adSettings;
/**
 * Sets the value of property AdSettings.
 */
-(void)setAdSettings:(SOMAAdSettings*)adSettings;
/**
 * Returns the value of property autoReloadEnabled.
 */
-(bool)autoReloadEnabled;
/**
 * Sets the value of property autoReloadEnabled.
 */
-(void)setAutoReloadEnabled:(bool)autoReloadEnabled;
/**
 * Returns the value of property autoReloadFrequency.
 */
-(int)autoReloadFrequency;
/**
 * Sets the value of property autoReloadFrequency.
 */
-(void)setAutoReloadFrequency:(int)autoReloadFrequency;
@end

// Actifsource ID=[c376ac6e-a2f0-11e0-bcee-59b6864167a2,d8fa047c-a164-11e0-930d-cf00c5c294d3]
