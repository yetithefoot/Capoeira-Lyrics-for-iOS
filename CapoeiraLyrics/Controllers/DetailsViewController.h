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
@interface DetailsViewController : BaseViewController< TagsViewProtocol> {
    IBOutlet UIScrollView* _scrollView;
    IBOutlet TagsView *_tagsView;
    IBOutlet UILabel *_labelTitle;
    IBOutlet TTTAttributedLabel *_labelText;
    Song * _song;
    
    
}

-(id) initWithSong: (Song *)song;


@end

