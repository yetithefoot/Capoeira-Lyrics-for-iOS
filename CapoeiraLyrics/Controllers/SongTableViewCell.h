//
//  SongTableViewCell.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 21.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongTableViewCell : UITableViewCell{
    
    IBOutlet UIImageView *_imageViewLogo;
    IBOutlet UILabel *_labelName;
    IBOutlet UILabel *_labelArtist;
    IBOutlet UIImageView *_imageView1;
    IBOutlet UIImageView *_imageView2;
    IBOutlet UIImageView *_imageView3;
    IBOutlet UIImageView *_imageView4;
    IBOutlet UIImageView *_imageView5;
    
    BOOL _flag1;
    BOOL _flag2;
    BOOL _flag3;
    BOOL _engTextAvailableFlag;
    BOOL _rusTextAvailableFlag;
}


-(void) setSong:(Song *)aSong;

@end
