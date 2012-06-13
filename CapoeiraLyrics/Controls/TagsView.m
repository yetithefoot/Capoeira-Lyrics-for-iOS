//
//  TagsView.m
//  todotogo
//
//  Created by Ivan Tarapon on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TagsView.h"
#import <QuartzCore/QuartzCore.h>

#define H_C_PADDING 10
#define V_PADDING 1
#define H_PADDING 2
#define V_MARGIN 6
#define H_MARGIN 2

@interface TagsView (privates)

- (void) makeLayout;

@end

@implementation TagsView

@synthesize delegate;
@synthesize tags = _tags;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder]))	{
		[self makeLayout];
	}
	return self;	
}

- (id) initWithFrame: (CGRect) frame {
	if((self = [super initWithFrame: frame])) {
		[self makeLayout];
	}
	return self;	
}

- (id) init {
	if((self = [super init])) {
		[self makeLayout];
	}
	return self;	
}

- (UIFont*) tagsFont{
    return [UIFont systemFontOfSize: 13];
}

- (UIFont*) titleFont{
    return [UIFont boldSystemFontOfSize: 13];
}

- (void) drawRect:(CGRect)rect {
    
    [super drawRect: rect];
    
    // draw cool border
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 2);
    CGContextAddLineToPoint(context, 320, 2);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, 320, rect.size.height-1);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextStrokePath(context);
    
}

- (void) layoutSubviews {
     [super layoutSubviews];
    
    UIFont* font = self.tagsFont;
    
    UIButton* label = [self.subviews objectAtIndex: 0];
    CGSize size = [[label titleForState: UIControlStateNormal] sizeWithFont: self.titleFont];
    label.frame = CGRectMake(H_C_PADDING, V_MARGIN, size.width + H_PADDING, size.height + V_PADDING);
    
    int currentX = CGRectGetMaxX(label.frame) + H_MARGIN;
    int currentY = V_MARGIN;
    
    int tagIndex = 0;
    for(Tag* tag in self.tags){
        UIButton* button = [self.subviews objectAtIndex: tagIndex + 1];
        NSString* text = [button titleForState: UIControlStateNormal];
        CGSize size = [text sizeWithFont: font];
        int width = size.width + H_PADDING;
        int height = size.height + V_PADDING;
        if(currentX + width > self.frame.size.width - 2 * H_C_PADDING){
            currentX = H_C_PADDING;
            currentY += height + V_PADDING;
        }
        button.frame = CGRectMake(currentX, currentY, width, height);
        currentX += width + H_PADDING;
        tagIndex++;
    }
    
    CGRect lastView = [self.subviews.lastObject frame];
    self.bounds = CGRectMake(0, 0, (int)self.bounds.size.width, (int)lastView.size.height + lastView.origin.y + V_MARGIN);
}

- (void) sizeToFit {
    [self layoutSubviews];
}



- (void) makeLayout {
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor colorWithRed: 221.0 / 225 green: 221.0 / 225 blue: 221.0 / 225 alpha: 1.0].CGColor;
    
    for(int i = self.subviews.count - 1; i >= 0; i--){
        [[self.subviews objectAtIndex: i] removeFromSuperview];
    }
    
    UIButton* label = [UIButton buttonWithType: UIButtonTypeCustom];
    label.titleLabel.font = self.titleFont;
    [label setTitle: NSLocalizedString(@"Tags:", @"") forState: UIControlStateNormal];
    label.backgroundColor = [UIColor clearColor];
    [label setTitleColor: [UIColor colorWithRed: 58/225. green: 58/225. blue: 58/225. alpha: 1.0] forState: UIControlStateNormal];
    label.userInteractionEnabled = false;
    [self addSubview: label];
    
    int tagIndex = 0;
    for(Tag* tag in self.tags){
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
        NSString* tagName = tag.name;
        if(tag != self.tags.lastObject){
            tagName = [tagName stringByAppendingString: @","];
        }
        
        [button setBackgroundColor: [UIColor clearColor]];
        [button.titleLabel setFont: self.tagsFont];
        [button setTitleColor: [UIColor colorWithRed: 106/225. green: 106/225. blue: 106/225. alpha: 1.0] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor blackColor] forState: UIControlStateHighlighted];
        [button setTitle: tagName forState: UIControlStateNormal];
        button.tag = tagIndex++;
        [button addTarget: self action: @selector(tagClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: button];
    }
}

- (void) tagClicked: (UIButton*) sender{
    Tag* tag = [self.tags objectAtIndex: sender.tag];
    [self.delegate tagsView: self didSelectTag: tag];
}

- (void) setTags:(NSArray *)tags {
    if(_tags != tags){
        [_tags release];
        _tags = [tags retain];
        [self makeLayout];
        [self setNeedsLayout];
    }
}

- (void) dealloc {
    [_tags release];
    [super dealloc];
}

@end