//
//  DetailsViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

#define VERTICAL_MARGIN_1 10
#define VERTICAL_MARGIN_2 10
#define VERTICAL_MARGIN_3 15
#define VERTICAL_MARGIN_4 20
#define VERTICAL_MARGIN_5 15
#define VERTICAL_MARGIN_6 10

- (void) relayout {
    float y = VERTICAL_MARGIN_1;
    
    [_labelTitle sizeToFit];
    CGRect rect = _labelTitle.bounds;
    _labelTitle.frame = CGRectMake(0, y, 320, rect.size.height);
    y += _labelTitle.frame.size.height + VERTICAL_MARGIN_2;
    
    CGSize size = [_labelText sizeThatFits: CGSizeMake(320, 0)];
    _labelText.frame = CGRectMake(0, y, 320, size.height);
    y += _labelText.frame.size.height+VERTICAL_MARGIN_6;
    
#warning uncomment for tags view reposition   
    /*
    [_tagsView sizeToFit];
    rect = _tagsView.bounds;
    _tagsView.frame = CGRectMake(0, y, 320, rect.size.height);
    y += _tagsView.frame.size.height+VERTICAL_MARGIN_5;
     */
    
    
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, y);
}

- (id)initWithSong:(Song *)song
{
    self = [super initWithNibName:@"DetailsViewController" bundle:nil];
    if (self) {
        _song = [song retain];
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tune label
    [_labelText setFont:[UIFont systemFontOfSize:FONT_TEXT_SIZE]];
    //[_labelText setLineHeightMultiple: 0.7];
    
    // prepare text
    [_labelText setText:_song.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        // find all bold strings
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[coro\\](.+)\\[\\/coro\\]" options:0 error:nil];
        NSArray *matches = [regex matchesInString:_song.text options:0 range:NSMakeRange(0, _song.text.length)];
        
        // init font
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:FONT_TEXT_SIZE];
        CTFontRef boldSystemFont_ct = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        
        // replace all bold/coro strings
        if(matches.count > 0 && boldSystemFont_ct){
            NSLog(@"%d matches found.", matches.count);
            for (NSTextCheckingResult *match in matches) {
                
                NSLog(@"match fount: %@", [_song.text substringWithRange:[match rangeAtIndex:1]]);
                
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
    
    
    _labelTitle.text = _song.name;

    self.navigationItem.title = _song.name;

    
    [self relayout];
}

- (void)viewDidUnload
{
    [_labelTitle release];
    _labelTitle = nil;
    [_labelText release];
    _labelText = nil;
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
@end
