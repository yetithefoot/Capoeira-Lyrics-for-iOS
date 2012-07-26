//
//  MasterViewController.h
//  dsgsd
//
//  Created by Vlad Tsepelev on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "CapoeiraLyricsAPI.h"
#import "BaseViewController.h"
#import "PlaceholderTableView.h"
#import "DetailsViewController.h"
#import "PrivateConstants.h"





@interface HDMasterViewController :  BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CapoeiraLyricsAPIDelegate, UITabBarDelegate, EGORefreshTableHeaderDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, DetailsViewControllerDelegate



>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    

    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
    
    NSMutableArray * _favedSongs;

    
    
    IBOutlet PlaceholderTableView *_tableSongs;
    IBOutlet UITabBar *_tabBar;
    IBOutlet UISegmentedControl *_segmentedFavedSwitcher;
    

    
}

@property (strong, nonatomic) DetailsViewController *detailViewController;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (IBAction)segmentedFavedValueChanged:(id)sender;


@end
