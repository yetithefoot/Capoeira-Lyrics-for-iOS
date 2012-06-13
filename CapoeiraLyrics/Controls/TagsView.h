//
//  TagsView.h
//  todotogo
//
//  Created by Ivan Tarapon on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@class TagsView;

@protocol TagsViewProtocol

- (void) tagsView: (TagsView*) tagsView didSelectTag: (Tag*) tag;

@end

@interface TagsView : UIView {
    NSArray* _tags;
}

@property (nonatomic,assign) id<TagsViewProtocol> delegate;
@property (nonatomic,retain) NSArray* tags;
@property (nonatomic,readonly) UIFont* tagsFont;
@property (nonatomic,readonly) UIFont* titleFont;

@end
