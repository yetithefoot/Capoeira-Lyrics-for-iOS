//
//  DetailsViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import <Foundation/Foundation.h>

#import "PrivateConstants.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize song = _song;
@synthesize songDelegate;

#define VERTICAL_MARGIN_1 10
#define VERTICAL_MARGIN_2 10
#define VERTICAL_MARGIN_3 15
#define VERTICAL_MARGIN_4 20
#define VERTICAL_MARGIN_5 15
#define VERTICAL_MARGIN_6 10

#ifdef HD_VERSION
#define VIEW_WIDTH 704
#else
#define VIEW_WIDTH 320
#endif



- (void) relayout {
    float y = VERTICAL_MARGIN_1;

    
    if(!_labelSwipeMessage.hidden){
        _labelSwipeMessage.frame = CGRectMake(0, y, VIEW_WIDTH, _labelSwipeMessage.frame.size.height);
        y += _labelSwipeMessage.frame.size.height;
    }
    
    [_labelTitle sizeToFit];
    CGRect rect = _labelTitle.bounds;
    _labelTitle.frame = CGRectMake(0, y, VIEW_WIDTH, rect.size.height);
    y += (_labelTitle.frame.size.height + VERTICAL_MARGIN_2);
    
    //[_labelText sizeToFit];
    CGSize size = [_labelText sizeThatFits: CGSizeMake(VIEW_WIDTH, 0)];
    _labelText.frame = CGRectMake(0, y, VIEW_WIDTH, size.height);
    y += (_labelText.frame.size.height+VERTICAL_MARGIN_6);
    
#warning uncomment for tags view reposition   
    /*
    [_tagsView sizeToFit];
    rect = _tagsView.bounds;
    _tagsView.frame = CGRectMake(0, y, 320, rect.size.height);
    y += _tagsView.frame.size.height+VERTICAL_MARGIN_5;
     */
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, y);
    
    // if lite version add banner to bottom
    if([Configuration isLiteVersion]){
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, 360);
    }
}



-(void) hideBackButton{
    NSMutableArray * items = [NSMutableArray arrayWithArray: _toolbar.items];
    for (UIView * view  in items) {
        if(view == ((UIView *)_btnBack)){

            //[items removeObject:view];
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = _btnBack.width;
            
            [items replaceObjectAtIndex:[items indexOfObject:_btnBack] withObject:fixedSpace];
            break;
        }
    }
    
    [_toolbar setItems: items animated:YES];


}
-(id) initWithSong: (Song *)aSong andHideBackButton:(BOOL) hideBackButton
{
    self = [super initWithNibName:@"DetailsViewController" bundle:nil];
    if (self) {
        _song = [aSong retain];
        
        _hideBackButton = hideBackButton;
        
        TEXT_SHARE_TO_FB = NSLocalizedString(@"Share to Facebook", @"");
        TEXT_SHARE_TO_TWITTER = NSLocalizedString(@"Share to Twitter", @"");
        TEXT_MAKE_FAVORITE = NSLocalizedString(@"Make favorite", @"");
        TEXT_UNMAKE_FAVORITE = NSLocalizedString(@"Unmake favorite", @"");
        TEXT_PLAY_VIDEO = NSLocalizedString(@"Open video", @"");
        TEXT_CANCEL = NSLocalizedString(@"Cancel", @"");
        
    }
    
    return self;
}

- (IBAction)btnBackClicked:(id)sender {
    [self goBack:sender];
}



- (IBAction)btnActionClicked:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    [popupQuery addButtonWithTitle:TEXT_SHARE_TO_FB];
    [popupQuery addButtonWithTitle:TEXT_SHARE_TO_TWITTER];
    [popupQuery addButtonWithTitle:(self.song.isFavorite?TEXT_UNMAKE_FAVORITE:TEXT_MAKE_FAVORITE)];
    if(_song.videoUrl)
        [popupQuery addButtonWithTitle:TEXT_PLAY_VIDEO];
    //if(_song.audioUrl)
    //    [popupQuery addButtonWithTitle:TEXT_PLAY_AUDIO];
    
    [popupQuery addButtonWithTitle:TEXT_CANCEL];
    [popupQuery setCancelButtonIndex:(popupQuery.numberOfButtons-1)];
    
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
    
    [popupQuery release];
    
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [videoView loadHTMLString:html baseURL:nil];
    videoView.center = CGPointMake(160, 120);
    [_scrollView addSubview:videoView];
    [videoView release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    
    if([btnTitle isEqualToString:TEXT_SHARE_TO_FB]){
        // share to fb
        NSString * urlString = [NSString stringWithFormat:@"http://capoeiralyrics.info/Songs/Details/%d", _song.identifier];
        NSString * message = [NSString stringWithFormat:@"Just learn %@ capoeira song by %@!", _song.name, _song.artist];
        NSURL *url = [NSURL URLWithString:urlString];
        SHKItem *item = [SHKItem URL:url title:message];

        // Share the item
        [SHKFacebook shareItem:item];

    }else if ([btnTitle isEqualToString:TEXT_SHARE_TO_TWITTER]) {
        // share to twitter
        NSString * urlString = [NSString stringWithFormat:@"http://capoeiralyrics.info/Songs/Details/%d", _song.identifier];
        NSString * message = [NSString stringWithFormat:@"Just learn %@ capoeira song by %@!", _song.name, _song.artist];
        NSURL *url = [NSURL URLWithString:urlString];
        SHKItem *item = [SHKItem URL:url title:message];

        // Share the item
        [SHKTwitter shareItem:item];
    }else if ([btnTitle isEqualToString:TEXT_PLAY_VIDEO]) {
        // play video
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_song.videoUrl]];
    }else if ([btnTitle isEqualToString:TEXT_PLAY_AUDIO]) {
        // play audio
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_song.audioUrl]];
    }else if ([btnTitle isEqualToString:TEXT_MAKE_FAVORITE] || [btnTitle isEqualToString:TEXT_UNMAKE_FAVORITE]) {
        self.song.favorite = !self.song.favorite;
        if([self.songDelegate respondsToSelector:@selector(madeSongFavourite:)]){
            [self.songDelegate performSelector:@selector(madeSongFavourite:) withObject:_song];
        }
    }
     
}

-(void) setSong:(Song *)song{
    if (song != _song)
    {
        [_song release];
        _song = [song retain];
        _imageViewBackground.image = [self backgroundImageForSong:_song];
        _labelText.tag = ORIG_TEXT;
        [self reloadData];
    }
}


-(void) reloadData{
    [self reloadData:ORIG_TEXT];
}

-(void) reloadData: (int) textType{
    
    // use text or its translation
    NSString * text = nil;
    
    _labelTitle.text = _song.name;
    _labelToolbarTitle.text = _song.name;
    _labelToolbarArtist.text = _song.artist;
    
    // tune swipes
    if(_song.engtext  || _song.rustext){
        _labelSwipeMessage.hidden = NO;

    }else {
        _labelSwipeMessage.hidden = YES;
    }
    
    [self refreshSwipeMessageByTag:textType];

    
    if(textType == ENG_TEXT) text = _song.engtext;
    else if(textType == RUS_TEXT) text = _song.rustext;
    else text = _song.text;
    
    
    // prepare text
    [_labelText setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        // find all bold strings
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[coro\\]([^\\[]+?)\\[\\/coro\\]" 
                                                                          options:NSRegularExpressionCaseInsensitive 
                                                                            error:nil];
        if(text) {
        
            NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
            
            [regex release];
            // init font
            UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:FONT_TEXT_SIZE];
            CTFontRef boldSystemFont_ct = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            // replace all bold/coro strings
            if(matches.count > 0 && boldSystemFont_ct){
                NSLog(@"%d matches found.", matches.count);
                for (NSTextCheckingResult *match in matches) {
                    
                    NSLog(@"match fount: %@", [text substringWithRange:[match rangeAtIndex:1]]);
                    
                    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:[match rangeAtIndex:1]];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldSystemFont_ct range:[match rangeAtIndex:1]];
                }
            }
            // release ct font
            if(boldSystemFont_ct) CFRelease(boldSystemFont_ct);
            
            // remove coro blocks
            [[mutableAttributedString mutableString] replaceOccurrencesOfString:@"[coro]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableAttributedString length])];
            [[mutableAttributedString mutableString] replaceOccurrencesOfString:@"[/coro]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableAttributedString length])];
        }
        
        return mutableAttributedString;
    }];

    [self relayout];
}



-(void) didSwipe:(UISwipeGestureRecognizer *) sender{
    
    
    if(!_song.engtext && !_song.rustext) return;
    
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        if(sender.direction == UISwipeGestureRecognizerDirectionLeft){
            if((_labelText.tag == ORIG_TEXT) && (_song.engtext)){
                _labelText.text = _song.engtext;
                _labelText.tag = ENG_TEXT;
            }
            
            else if((_labelText.tag == ORIG_TEXT) && (!_song.engtext) && (_song.rustext)){
                _labelText.text = _song.rustext;
                _labelText.tag = RUS_TEXT;
            }
            
            else if((_labelText.tag == ENG_TEXT) &&  (_song.rustext)){
                _labelText.text = _song.rustext;
                _labelText.tag = RUS_TEXT;
            }
            
            [self reloadData:_labelText.tag];
            
        }else if(sender.direction == UISwipeGestureRecognizerDirectionRight){
            if((_labelText.tag == RUS_TEXT) && (_song.engtext)){
                _labelText.text = _song.engtext;
                _labelText.tag = ENG_TEXT;
            }
            
            else if((_labelText.tag == RUS_TEXT) && (!_song.engtext) && (_song.text)){
                _labelText.text = _song.text;
                _labelText.tag = ORIG_TEXT;
            }
            
            else if((_labelText.tag == ENG_TEXT) &&  (_song.text)){
                _labelText.text = _song.text;
                _labelText.tag = ORIG_TEXT;
            }
            
            [self reloadData:_labelText.tag];
        }
        
        //[self refreshSwipeMessageByTag:_labelText.tag];
    }
}

-(void) refreshSwipeMessageByTag:(int) tag{
    
    NSString *leftAvailable = @"← Swipe to select language";
    NSString *bothAvailable = @"← Swipe to select language →";
    NSString *rightAvailable = @"Swipe to select language →";
    
    if(tag == ORIG_TEXT && (_song.engtext || _song.rustext))
        _labelSwipeMessage.text = rightAvailable;
    else if(tag == ENG_TEXT && _song.text && _song.rustext)
        _labelSwipeMessage.text = bothAvailable;
    else if(tag == ENG_TEXT && _song.text && !_song.rustext)
        _labelSwipeMessage.text = leftAvailable;
    else if(tag == ENG_TEXT && !_song.text && _song.rustext)
        _labelSwipeMessage.text = rightAvailable;
    else if(tag == RUS_TEXT && (_song.text || _song.engtext))
        _labelSwipeMessage.text = leftAvailable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizerSwipeLeft = 
    [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
    recognizerSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scrollView addGestureRecognizer:recognizerSwipeLeft];
    
    UISwipeGestureRecognizer *recognizerSwipeRight = 
    [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
    recognizerSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_scrollView addGestureRecognizer:recognizerSwipeRight];
    

    
#ifdef LITE_VERSION
    {
        mBannerView = [[SOMABannerView alloc] initWithDimension:kSOMAAdDimensionDefault]; 
        mBannerView.frame = CGRectMake(0, 410, 320, 50);
        [mBannerView adSettings].adspaceId = [PrivateConstants smaatoAdSpace1];
        [mBannerView adSettings].publisherId = [PrivateConstants smaatoPublisherId]; 
        [mBannerView addAdListener:self];
        [self.view addSubview:mBannerView];
        [mBannerView release];
    }
#endif
    
    // set bg
    _imageViewBackground.image = [self backgroundImageForSong:_song];
    
    // tune label
    _labelText.tag = ORIG_TEXT; // original text flag
    [self refreshSwipeMessageByTag:_labelText.tag];
    [_labelText setFont:[UIFont systemFontOfSize:FONT_TEXT_SIZE]];
    
    
            
    
    [self reloadData];
}

-(UIImage *) backgroundImageForSong:(Song *)aSong{
    
    // cdo
    if(([aSong.artist rangeOfString:@"mestre suassuna" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"cordao de ouro" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_cdo"];
    }
    // ficag
    if(([aSong.artist rangeOfString:@"mestre museu" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"ficag" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_ficag"];
    }
    // axe
    if(([aSong.artist rangeOfString:@"mestre barrao" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"axe capoeria" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_axe"];
    }
    // abada
    if(([aSong.artist rangeOfString:@"mestre camisa" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"abada capoeira" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_abada"];
    }
    // muzenza
    if(([aSong.artist rangeOfString:@"mestre burgues" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"grupo muzenza" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_muzenza"];
    }
    // gerais
    if(([aSong.artist rangeOfString:@"mestre mao branca" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound) ||
       ([aSong.artist rangeOfString:@"capoeira gerais" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_gerais"];
    }
    // jogo de dentro
    if(([aSong.artist rangeOfString:@"jogo de dentro" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_sementedojogodeangola"];
    }
    // uca
    if(([aSong.artist rangeOfString:@"mestre acordeon" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_uca"];
    }
    // mundo
    if(([aSong.artist rangeOfString:@"mundo capoeira" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)){
        return [UIImage imageNamed:@"background_mundo"];
    }
    
    return [UIImage imageNamed:@"background_default"];
}

-(void)viewWillAppear:(BOOL)animated { 
    [super viewWillAppear:animated];
    
    if(_hideBackButton){
        [self hideBackButton];
    }
    
#ifdef LITE_VERSION
    {
        [mBannerView setAutoReloadEnabled:YES]; 
        [mBannerView asyncLoadNewBanner];
    }
#endif
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#ifdef LITE_VERSION
    {
        [mBannerView setAutoReloadEnabled:NO]; 
    }
#endif
}

- (void)viewDidUnload
{
    [_labelTitle release];
    _labelTitle = nil;
    [_labelText release];
    _labelText = nil;
    [_labelToolbarTitle release];
    _labelToolbarTitle = nil;
    [_labelToolbarArtist release];
    _labelToolbarArtist = nil;
    [_labelSwipeMessage release];
    _labelSwipeMessage = nil;
    [_imageViewBackground release];
    _imageViewBackground = nil;
    [_btnBack release];
    _btnBack = nil;
    [_toolbar release];
    _toolbar = nil;
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
#ifdef HD_VERSION
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
#else
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
#endif
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self relayout];
}

- (void)dealloc {
    [_labelTitle release];
    [_labelText release];
    [_scrollView release];
    [_tagsView release];
    [_song release];
    [_labelToolbarTitle release];
    [_labelToolbarArtist release];
    [_labelSwipeMessage release];
    [_imageViewBackground release];
    [_btnBack release];
    [_toolbar release];
    [super dealloc];
}

- (void) tagsView:(TagsView *)tagsView didSelectTag:(Tag *)tag {   
    
    /*UIViewController* prevController = [_navConroller.viewControllers objectAtIndex: _navConroller.viewControllers.count - 2];
    if([prevController class] == [TagEventsViewController class]){
        [_navConroller popViewControllerAnimated: false];
        [_navConroller popViewControllerAnimated: false];
    }
    
    TagEventsViewController * controller = [[TagEventsViewController alloc] initWithTag: tag]; 
    [_navConroller pushViewController: controller animated: YES];
    [controller release];*/
}

#pragma mark api delegate


-(void)songDidLoad:(Song *)aSong{
    self.song = aSong;
    [self reloadData];
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
}


-(void)didFail{
    [SVProgressHUD showErrorWithStatus:@"Update failed! Try again later!"];
}

#pragma mark AdListenerProtocol 
#ifdef LITE_VERSION
-(void)onReceiveAd:(id<SOMAAdDownloaderProtocol>)sender withReceivedBanner:(id<SOMAReceivedBannerProtocol>)receivedBanner
{
    // disable scrolltotop and bouncing for banner view
    if(sender && [sender isKindOfClass:[SOMABannerView class]]){
        [self disableScrollsToTopPropertyOnAllSubviewsOf:(SOMABannerView *)sender];
    }
}
#endif

@end
