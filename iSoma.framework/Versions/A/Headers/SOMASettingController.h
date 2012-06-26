//
//  SOMASettingController.h
//  SOMASource
//
//  Copyright ©2009-10 Smaato, Inc.  All Rights Reserved.  Use of this software is subject to the Smaato Terms of Service. 
//
#pragma once
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SOMASettingControllerDelegate;
@interface SOMASettingController : UIViewController<UITextFieldDelegate> {
	id<SOMASettingControllerDelegate> delegate;
	UITextField *gender;
	UITextField *yearofbirth;
	UITextField *interest1;
	UITextField *interest2;
	UITextField *interest3;
}
@property (nonatomic, assign) id<SOMASettingControllerDelegate> delegate;
@end

@protocol SOMASettingControllerDelegate
- (void)settingViewControllerDismiss:(SOMASettingController *)controller;
@end