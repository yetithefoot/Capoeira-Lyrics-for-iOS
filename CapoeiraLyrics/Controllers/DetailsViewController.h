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


@interface DetailsViewController : BaseViewController< TagsViewProtocol,UIActionSheetDelegate, CapoeiraLyricsAPIDelegate> {
    IBOutlet UIScrollView* _scrollView;
    IBOutlet TagsView *_tagsView;
    IBOutlet UILabel *_labelTitle;
    IBOutlet TTTAttributedLabel *_labelText;
    IBOutlet UILabel *_labelToolbarTitle;
    IBOutlet UILabel *_labelToolbarArtist;
    Song * _song;
    
    NSString *TEXT_SHARE_TO_FB;
    NSString *TEXT_SHARE_TO_TWITTER;
    NSString *TEXT_MAKE_FAVORITE;
    NSString *TEXT_UNMAKE_FAVORITE;
    NSString *TEXT_PLAY_VIDEO;
    NSString *TEXT_PLAY_AUDIO;
    NSString *TEXT_CANCEL;
    
}

@property (nonatomic, retain) Song *song;

-(id) initWithSong: (Song *)aSong;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnActionClicked:(id)sender;


@end

