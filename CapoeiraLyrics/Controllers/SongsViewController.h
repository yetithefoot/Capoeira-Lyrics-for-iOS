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

@interface SongsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CapoeiraLyricsAPIDelegate>{
    NSMutableArray * _songs;
    NSMutableArray  *_filteredSongs;   // The content filtered as a result of a search.
    

    IBOutlet UITableView *_tableSongs;
    

}



@end
