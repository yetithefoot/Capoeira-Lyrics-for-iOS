//
//  PlaceholderTableView.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 21.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTableView : UITableView{
    UIView *_placeholderView;
    UILabel * _placeholderText;
}

@property (nonatomic,readonly) bool tableViewHasRows;

@end
