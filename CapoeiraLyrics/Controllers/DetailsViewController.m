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



@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize song = _song;

#define VERTICAL_MARGIN_1 10
#define VERTICAL_MARGIN_2 10
#define VERTICAL_MARGIN_3 15
#define VERTICAL_MARGIN_4 20
#define VERTICAL_MARGIN_5 15
#define VERTICAL_MARGIN_6 10

- (void) relayout {
    float y = VERTICAL_MARGIN_1;
    
    if(!_labelSwipeMessage.hidden){
        y += _labelSwipeMessage.frame.size.height;
    }
    
    [_labelTitle sizeToFit];
    CGRect rect = _labelTitle.bounds;
    _labelTitle.frame = CGRectMake(0, y, 320, rect.size.height);
    y += (_labelTitle.frame.size.height + VERTICAL_MARGIN_2);
    
    //[_labelText sizeToFit];
    CGSize size = [_labelText sizeThatFits: CGSizeMake(320, 0)];
    _labelText.frame = CGRectMake(0, y, 320, size.height);
    y += (_labelText.frame.size.height+VERTICAL_MARGIN_6);
    
#warning uncomment for tags view reposition   
    /*
    [_tagsView sizeToFit];
    rect = _tagsView.bounds;
    _tagsView.frame = CGRectMake(0, y, 320, rect.size.height);
    y += _tagsView.frame.size.height+VERTICAL_MARGIN_5;
     */
    
    
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, y);
}

- (id)initWithSong:(Song *)aSong
{
    self = [super initWithNibName:@"DetailsViewController" bundle:nil];
    if (self) {
        _song = [aSong retain];
        
        TEXT_SHARE_TO_FB = NSLocalizedString(@"Share to Facebook", @"");
        TEXT_SHARE_TO_TWITTER = NSLocalizedString(@"Share to Twitter", @"");
        TEXT_MAKE_FAVORITE = NSLocalizedString(@"Make favorite", @"");
        TEXT_UNMAKE_FAVORITE = NSLocalizedString(@"Unmake favorite", @"");
        TEXT_PLAY_VIDEO = NSLocalizedString(@"Open video", @"");
        //TEXT_PLAY_AUDIO = NSLocalizedString(@"Open audio", @"");
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
        item.shareType = SHKShareTypeURL;

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
    }
     
}


-(void) reloadData{
    [self reloadData:ORIG_TEXT];
}

-(void) reloadData: (int) textType{
    
    // use text or its translation
    NSString * text = nil;
    
    if(textType == ENG_TEXT) text = _song.engtext;
    else if(textType == RUS_TEXT) text = _song.rustext;
    else text = _song.text;
    
    
    // prepare text
    [_labelText setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        // find all bold strings
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[coro\\]([^\\[]+?)\\[\\/coro\\]" 
                                                                          options:NSRegularExpressionCaseInsensitive 
                                                                            error:nil];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        
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
        
        
        return mutableAttributedString;
    }];

    [self relayout];
}



-(void) didSwipe:(UISwipeGestureRecognizer *) sender{
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
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    // tune label
    _labelText.tag = ORIG_TEXT; // original text flag
    [_labelText setFont:[UIFont systemFontOfSize:FONT_TEXT_SIZE]];
    //[_labelText setLineHeightMultiple:0.7];
    
    _labelTitle.text = _song.name;
    _labelToolbarTitle.text = _song.name;
    _labelToolbarArtist.text = _song.artist;
    
    //if(_song.videoUrl)
    //    [self embedYouTube:_song.videoUrl frame:CGRectMake(0, 0, 320, 240)];
    
    // tune swipes
    if(_song.engtext  || _song.rustext){
        _labelSwipeMessage.hidden = NO;
        UISwipeGestureRecognizer *recognizerSwipeLeft = 
        [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
        recognizerSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [_scrollView addGestureRecognizer:recognizerSwipeLeft];
        
        UISwipeGestureRecognizer *recognizerSwipeRight = 
        [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
        recognizerSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [_scrollView addGestureRecognizer:recognizerSwipeRight];
    }else {
        _labelSwipeMessage.hidden = YES;
    }
        
    
    [self reloadData];
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
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
@end
