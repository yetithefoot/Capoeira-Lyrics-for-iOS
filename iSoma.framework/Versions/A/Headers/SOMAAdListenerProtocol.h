#pragma once

// Begin Protected Region [[246a693e-a16f-11e0-930d-cf00c5c294d3,imports]]
#import "SOMAReceivedBannerProtocol.h"
@protocol SOMAAdDownloaderProtocol;
// End Protected Region   [[246a693e-a16f-11e0-930d-cf00c5c294d3,imports]]

/**
 * ©2011 Smaato, Inc. All Rights Reserved. Use of this software is subject to
 * the Smaato Terms of Service.
 */ 
@protocol SOMAAdListenerProtocol <NSObject>
/**
 * Called when a new banner has been received and is about to be displayed.
 */
-(void)onReceiveAd:(id<SOMAAdDownloaderProtocol>)sender withReceivedBanner:(id<SOMAReceivedBannerProtocol>)receivedBanner;
@end

// Actifsource ID=[c376ac6e-a2f0-11e0-bcee-59b6864167a2,246a693e-a16f-11e0-930d-cf00c5c294d3]
