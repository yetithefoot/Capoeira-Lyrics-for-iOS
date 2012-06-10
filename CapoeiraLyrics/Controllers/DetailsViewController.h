//
//  DetailsViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailsViewController : BaseViewController{
    Song * _song;

    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelText;
}

-(id) initWithSong: (Song *)song;



@end
