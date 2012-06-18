//
//  BaseViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapoeiraLyricsAPI.h"

@interface BaseViewController : UIViewController<CapoeiraLyricsAPIDelegate, UITabBarControllerDelegate>{
    CapoeiraLyricsAPI * _api;
}

-(void) showAlertWithTitle: (NSString *) title andMessage: (NSString *) message;
- (void) goBack: (id) sender;

@end
