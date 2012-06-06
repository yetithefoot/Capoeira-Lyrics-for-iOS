//
//  FirstViewController.h
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
    

    IBOutlet UITableView *_tableSongs;
    

}



@end
