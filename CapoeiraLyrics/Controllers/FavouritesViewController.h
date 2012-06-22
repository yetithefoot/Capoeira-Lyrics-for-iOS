//
//  FavouritesViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PlaceholderTableView.h"

@interface FavouritesViewController : BaseViewController<UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UIGestureRecognizerDelegate>{
    
    IBOutlet UITabBar *_tabBar;
    IBOutlet PlaceholderTableView *_tableSongs;

    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
}

- (id)initWithArray:(NSArray *) aSongs;

@end
