//
//  DetailsViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

#import "TagsView.h"


@interface DetailsViewController : BaseViewController< TagsViewProtocol> {
    IBOutlet UIScrollView* _scrollView;
    IBOutlet TagsView *_tagsView;
    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelText;
    Song * _song;
    
    
}

-(id) initWithSong: (Song *)song;


@end

