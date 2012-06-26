//
//  ToastBannerView.h
//  SOMADemo
//
//  Created by Gerrit Alves on 01.07.11.
//  Copyright 2011 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMAAdDownloaderProtocol.h"
#import "SOMABannerView.h"
#import "SOMAAdListenerProtocol.h"

@interface SOMAToastBannerView : UIView <SOMAAdDownloaderProtocol, SOMAAdListenerProtocol, SOMABannerViewDelegate> {
    UIButton * mCloseButton;
    SOMABannerView * mBannerView;
    NSMutableArray * mAdListener;
}

/**
 * Holds the banner delegate to open the landing page.
 */
@property (nonatomic, assign) id<SOMABannerViewDelegate> delegate;
@property (nonatomic, retain) UIColor* backgroundColor;

@end
