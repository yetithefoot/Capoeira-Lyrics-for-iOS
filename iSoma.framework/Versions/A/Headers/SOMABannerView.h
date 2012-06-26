//
//  BannerView.h
//  SOMADemo
//
//  Created by Gerrit Alves on 01.07.11.
//  Copyright 2011 Smaato Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef ARMV6
#import <MediaPlayer/MediaPlayer.h>
#endif
#import <QuartzCore/QuartzCore.h>
#import "SOMAAdDownloaderProtocol.h"
#import "SOMABannerViewDelegate.h"
#import "SOMAAdDimensionEnum.h"

/* Control of animation */
typedef enum {
	kSOMAAnimationTypeRandom   = 0,		//Random
	kSOMAAnimationTypeMoveIn   = 1,		//Move
	kSOMAAnimationTypePush     = 2,		//Push
	kSOMAAnimationTypeReveal   = 3,		//Reveal
	kSOMAAnimationTypeFade     = 4,		//Fade
	kSOMAAnimationTypeNone     = 5     //Turn off animation
} SOMAAnimationType;
/* Control of animation Direction */
typedef enum {
	kSOMAAnimationDirectionRandom = 0,	//Random
    kSOMAAnimationDirectionLeft     = 1,		//From Left
	kSOMAAnimationDirectionRight    = 2,		//From Right
	kSOMAAnimationDirectionTop      = 3,		//From Top
	kSOMAAnimationDirectionBottom   = 4		//From Bottom
} SOMAAnimationDirection;

@class SOMAAutoReloadTimer;
@class ORMMAConnector;

@interface SOMABannerView : UIView<SOMAAdDownloaderProtocol, SOMAAdListenerProtocol, UIWebViewDelegate> {
    NSObject<SOMAAdDownloaderProtocol>* mDownloader;
    bool mLoading;
    NSObject<SOMAReceivedBannerProtocol>* mLastReceivedBanner;
    UIView * mCurrentView;
    UIView * mLastView;
    NSMutableArray * mAdListener;
    UIActivityIndicatorView * mActivityIndicator;
#ifndef ARMV6
    MPMoviePlayerController* mMoviePlayer;
    bool mPlayingVideo;
    bool mLoadingVideo;
#endif
    SOMAAutoReloadTimer * mReloadTimer;
    ORMMAConnector* mORMMAConnector;
}

@property (nonatomic) SOMAAnimationType animationType;
@property (nonatomic) SOMAAnimationDirection animationDirection;
@property (nonatomic, assign) id<SOMABannerViewDelegate> delegate;
@property (nonatomic, retain) UIColor* backgroundColor;

-(id)initWithDimension:(SOMAAdDimension)dimension;
-(CATransition*) createAnimation:(SOMAAnimationType)control withDirection:(SOMAAnimationDirection)direction;
-(void)stopVideoPlayback;
@end
