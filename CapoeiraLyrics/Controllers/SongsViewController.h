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
#import "CMIndexBar.h"

#ifdef LITE_VERSION
#import <iSoma/SOMABannerView.h>
#endif

@interface SongsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CapoeiraLyricsAPIDelegate, UITabBarDelegate, EGORefreshTableHeaderDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, CMIndexBarDelegate

#ifdef LITE_VERSION
,SOMAAdListenerProtocol
#endif

>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
    
    CMIndexBar * _indexBar;
    IBOutlet PlaceholderTableView *_tableSongs;
    IBOutlet UITabBar *_tabBar;
    
#ifdef LITE_VERSION
    SOMABannerView *mBannerView;
#endif
    
}


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
