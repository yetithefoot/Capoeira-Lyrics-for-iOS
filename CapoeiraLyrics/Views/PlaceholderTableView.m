//
//  PlaceholderTableView.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 21.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceholderTableView.h"

@implementation PlaceholderTableView



-(void) initPlaceholderView{
    _placeholderView = [[UIView alloc]init];
    _placeholderView.backgroundColor = [UIColor clearColor];
    _placeholderText = [[UILabel alloc]init];
    _placeholderText.textAlignment = UITextAlignmentCenter;
    //_placeholderText.backgroundColor = [UIColor clearColor];
    _placeholderText.font = [UIFont boldSystemFontOfSize:22];
    _placeholderText.textColor = [UIColor grayColor];
    _placeholderText.text = NSLocalizedString(@"No favorite songs... =(", @"No favorite songs");
    _placeholderText.center = _placeholderView.center;
    [_placeholderView addSubview:_placeholderText];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initPlaceholderView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initPlaceholderView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPlaceholderView];
    }
    return self;
}

-(void)awakeFromNib{
    [self initPlaceholderView];
}

- (bool) tableViewHasRows
{
    return [self numberOfRowsInSection:0] == 0;
}

- (void) updateEmptyPage
{
    const CGRect rect = self.frame;
    _placeholderView.frame  = rect;
    _placeholderText.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    //_placeholderText.center = _placeholderView.center;
    
    const bool shouldShowEmptyView = self.tableViewHasRows;
    const bool emptyViewShown      = _placeholderView.superview != nil;
    
    if (shouldShowEmptyView == emptyViewShown) return;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self layer] addAnimation:animation forKey:kCATransitionReveal];
    
    if (shouldShowEmptyView){
        [self.superview addSubview:_placeholderView];
    }
    else{
        [_placeholderView removeFromSuperview];
    }
}

#pragma mark UIView

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self updateEmptyPage];
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // Prevent any interaction when the empty view is shown
    const bool emptyViewShown = _placeholderView.superview != nil;
    return emptyViewShown ? nil : [super hitTest:point withEvent:event];
}

#pragma mark UITableView

- (void) reloadData
{
    [super reloadData];
    [self updateEmptyPage];
}

- (void)dealloc
{
    [_placeholderView release];
    [_placeholderText release];
    [super dealloc];
}

@end
