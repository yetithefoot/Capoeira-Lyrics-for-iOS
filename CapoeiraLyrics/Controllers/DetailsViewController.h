//
//  DetailsViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

#import "TTTAttributedLabel.h"

#import "TagsView.h"

#define FONT_TEXT_SIZE 16.0

#define ORIG_TEXT 0
#define ENG_TEXT 1
#define RUS_TEXT 2

#ifdef LITE_VERSION
#import <iSoma/SOMABannerView.h>
#endif

@protocol DetailsViewControllerDelegate <NSObject>

@optional

-(void) madeSongFavourite: (Song *) song;

@end

@interface DetailsViewController : BaseViewController< TagsViewProtocol,UIActionSheetDelegate, CapoeiraLyricsAPIDelegate 

#ifdef LITE_VERSION
,SOMAAdListenerProtocol
#endif
> {
    IBOutlet UIScrollView* _scrollView;
    IBOutlet TagsView *_tagsView;
    IBOutlet UILabel *_labelTitle;
    IBOutlet TTTAttributedLabel *_labelText;
    IBOutlet UILabel *_labelSwipeMessage;
    IBOutlet UILabel *_labelToolbarTitle;
    IBOutlet UILabel *_labelToolbarArtist;
    IBOutlet UIImageView *_imageViewBackground;
    IBOutlet UIBarButtonItem *_btnBack;
    IBOutlet UIToolbar *_toolbar;
    Song * _song;
    BOOL _hideBackButton;
    
    
    
    NSString *TEXT_SHARE_TO_FB;
    NSString *TEXT_SHARE_TO_TWITTER;
    NSString *TEXT_MAKE_FAVORITE;
    NSString *TEXT_UNMAKE_FAVORITE;
    NSString *TEXT_PLAY_VIDEO;
    NSString *TEXT_PLAY_AUDIO;
    NSString *TEXT_CANCEL;
    NSString *TEXT_OPEN_IN_BROWSER;
    
#ifdef LITE_VERSION
    SOMABannerView *mBannerView;
#endif
    
}



@property (nonatomic, retain) Song *song;
@property (nonatomic, assign) id<DetailsViewControllerDelegate> songDelegate;

-(id) initWithSong: (Song *)aSong andHideBackButton:(BOOL) hideBackButton;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnActionClicked:(id)sender;

-(void) reloadData;
- (void) relayout;


@end

