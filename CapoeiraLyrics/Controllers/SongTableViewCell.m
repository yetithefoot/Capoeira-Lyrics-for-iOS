//
//  SongTableViewCell.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 21.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell

-(void)initialize{

}

-(void)awakeFromNib{
    [self initialize];
}

-(id)init{
    if(self = [super init]){
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self initialize];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refreshIcons{
    
    // set default position for icons
    
    _imageView1.frame = CGRectMake(10, 40, 16, 16);
    _imageView2.frame = CGRectMake(36, 40, 16, 16);
    _imageView3.frame = CGRectMake(62, 40, 16, 16);
    _imageView4.frame = CGRectMake(88, 40, 16, 16);
    
    
    // hide all icons
    _imageView1.hidden = !_flag1;
    _imageView2.hidden = !_flag2;
    _imageView3.hidden = !_flag3;
    _imageView4.hidden = !_engTextAvailableFlag;
    _imageView5.hidden = !_rusTextAvailableFlag;
    
    
    // relayout this icons
    if (_imageView1.hidden) {
        _imageView2.frame = CGRectMake(_imageView2.frame.origin.x-26, 40, 16, 16);
        _imageView3.frame = CGRectMake(_imageView3.frame.origin.x-26, 40, 16, 16);
        _imageView4.frame = CGRectMake(_imageView4.frame.origin.x-26, 40, 16, 16);
        _imageView5.frame = CGRectMake(_imageView5.frame.origin.x-26, 40, 16, 16);
    }
    if (_imageView2.hidden) {
        _imageView3.frame = CGRectMake(_imageView3.frame.origin.x-26, 40, 16, 16);
        _imageView4.frame = CGRectMake(_imageView4.frame.origin.x-26, 40, 16, 16);
        _imageView5.frame = CGRectMake(_imageView5.frame.origin.x-26, 40, 16, 16);
    }
    if (_imageView3.hidden) {
        _imageView4.frame = CGRectMake(_imageView4.frame.origin.x-26, 40, 16, 16);
        _imageView5.frame = CGRectMake(_imageView5.frame.origin.x-26, 40, 16, 16);
    }
    if (_imageView4.hidden) {
        _imageView5.frame = CGRectMake(_imageView5.frame.origin.x-26, 40, 16, 16);
    }

    
}


-(void) setSong:(Song *)aSong{
    _labelName.text = aSong.name;
    _labelArtist.text = aSong.artist;
    // Custom initialization
    _flag1 = (aSong.isFavorite);
#warning until music links is not absolute - hide audio icon to not frustrate user
    _flag2 = false;//((aSong.audioUrl != nil) && ((CFNullRef)aSong.audioUrl != kCFNull));
    _flag3 = ((aSong.videoUrl != nil) && ((CFNullRef)aSong.videoUrl  != kCFNull));
    _engTextAvailableFlag = ((aSong.engtext != nil) && ((CFNullRef)aSong.engtext != kCFNull));
    _rusTextAvailableFlag = ((aSong.rustext != nil) && ((CFNullRef)aSong.rustext != kCFNull));
    
    _imageViewLogo.image = [self cellImageForSong:aSong];
    
    // refresh icons depends on flags
    [self refreshIcons];
}


-(UIImage *) cellImageForSong:(Song *)aSong{
    
    // cdo
    if(([aSong.artist rangeOfString:@"mestre suassuna" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
    ([aSong.artist rangeOfString:@"cordao de ouro" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_cdo"];
    }
    // axe
    if(([aSong.artist rangeOfString:@"mestre barrao" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"axe capoeria" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_axe"];
    }
    // abada
    if(([aSong.artist rangeOfString:@"mestre camisa" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"abada capoeira" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_abada"];
    }
    // muzenza
    if(([aSong.artist rangeOfString:@"mestre burgues" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"grupo muzenza" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_muzenza"];
    }
    // gerais
    if(([aSong.artist rangeOfString:@"mestre mao branca" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"capoeira gerais" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_gerais"];
    }
    // jogo de dentro
    if(([aSong.artist rangeOfString:@"jogo de dentro" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_sementedojogodeangola"];
    }
    // uca
    if(([aSong.artist rangeOfString:@"mestre acordeon" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_uca"];
    }
    // ьгтвщ
    if(([aSong.artist rangeOfString:@"mundo capoeira" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"logo_mundo"];
    }
    
    return [UIImage imageNamed:@"logo_default"];
}

- (void)dealloc {
    [_imageViewLogo release];
    [_labelName release];
    [_labelArtist release];
    [_imageView1 release];
    [_imageView2 release];
    [_imageView3 release];
    [_imageView4 release];
    [_imageView5 release];
    [super dealloc];
}
@end
