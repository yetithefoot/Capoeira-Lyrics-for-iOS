//
//  BannerViewDelegate.h
//  SOMADemo
//
//  Created by Gerrit Alves on 01.07.11.
//  Copyright 2011 Smaato Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOMABannerView;
@protocol SOMABannerViewDelegate <NSObject>
@optional
- (void)landingPageWillBeDisplayed;
- (void)landingPageHasBeenClosed;
@end
