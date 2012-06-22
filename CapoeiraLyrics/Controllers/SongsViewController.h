//
//  FirstViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapoeiraLyricsAPI.h"
#import "BaseViewController.h"
#import "PlaceholderTableView.h"

@interface SongsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CapoeiraLyricsAPIDelegate, UITabBarDelegate, EGORefreshTableHeaderDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
    

    IBOutlet PlaceholderTableView *_tableSongs;
    IBOutlet UITabBar *_tabBar;
    
}


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
