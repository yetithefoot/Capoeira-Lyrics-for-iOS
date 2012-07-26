//
//  MasterViewController.m
//  dsgsd
//
//  Created by Vlad Tsepelev on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDMasterViewController.h"

#import "SongTableViewCell.h"



@interface HDMasterViewController () {
 
}
@end

@implementation HDMasterViewController



@synthesize detailViewController = _detailViewController;

#pragma mark api

-(void) startLoadSongs{
    // show waiting hud
    [SVProgressHUD showWithStatus:@"Loading songs update..." maskType:SVProgressHUDMaskTypeBlack];
    // start load songs async
    [_api getAllSongsFull];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Songs", @"Songs");
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        
        _songs = [[NSMutableArray alloc]init];
        _filteredSongs = [[NSMutableArray alloc] init];
    }
    return self;
}
							

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);;
}

-(void)dealloc{
    _refreshHeaderView=nil; // only niling, its retained by tableview
    
    [_songs release];
    _songs = nil;
    [_filteredSongs release];
    _filteredSongs = nil;
    
    
    [_tableSongs release];
    [_tabBar release];
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.detailViewController.songDelegate = self;
	
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableSongs.bounds.size.height, self.view.frame.size.width, _tableSongs.bounds.size.height)arrowImageName:@"grayArrow.png" textColor:[UIColor lightGrayColor]];
        
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        
		[_tableSongs addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    [self.searchDisplayController setActive:NO];
    [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:0];
    // hide searchbar
    //[_tableSongs setContentOffset:CGPointMake(0, 44)];
    
    [_api getAllSongsFullFromLocalStorage];
    
    // check for new items if check
    if([Configuration checkForUpdatesAtStart])
        [_api getSongsCount];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // select tabbar item "songs"
    // actually we need select item with name "songs"
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];
    [_tableSongs reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];


}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidUnload
{
    
    _refreshHeaderView=nil;
    [_tableSongs release];
    _tableSongs = nil;
    [_tabBar release];
    _tabBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark Song details delegate

-(void)madeSongFavourite:(Song *)song{
    [_tableSongs reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData]; 
}


#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    [self startLoadSongs];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableSongs];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return NO; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



//int __lastClickedCell2 = -1;

/*-(void) makeFavorite:(id) sender{
    Song * song = [Song  getSongByIdentifier:__lastClickedCell2 inArray:_songs];
    
    if(song){
        BOOL isFavorite = song.favorite;
        song.favorite = !isFavorite;
        
        [_tableSongs reloadData]; //reload main table
        [self.searchDisplayController.searchResultsTableView reloadData]; //reload table under search context (All, Text, Name, Artist etc.)
    }    
    
}*/


/*
-(void)cellLongPressed :(UILongPressGestureRecognizer *) sender
{
    if(sender.state == UIGestureRecognizerStateBegan){
        
        Song * song = [Song  getSongByIdentifier:sender.view.tag inArray:_songs];
        
        if(song){
            __lastClickedCell2 = sender.view.tag;
            [sender.view.superview becomeFirstResponder];
            
            UIMenuController * menu = [UIMenuController sharedMenuController];
            
            UIMenuItem * itemFavorite = [[[UIMenuItem alloc]initWithTitle:((song.favorite)?@"Unmake favorite":@"Make favorite") action:@selector(makeFavorite:)] autorelease];
            UIMenuItem * itemPlayVideo = nil;
            if(song.videoUrl)
                itemPlayVideo = [[[UIMenuItem alloc]initWithTitle:@"Play video" action:@selector(openVideo:)] autorelease];
            
            [menu setMenuItems:[NSArray arrayWithObjects:itemFavorite, itemPlayVideo, nil]];
            [menu setTargetRect:sender.view.frame inView:sender.view.superview];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}*/

#pragma tableview datasource + delegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if ([[self.states objectAtIndex:section] count] > 0) {
//        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//    }
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_filteredSongs count];
    }
	else
	{
        return [_songs count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongTableViewCell"];
    
    if (cell == nil) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SongTableViewCell" owner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    
    // fill favorite song image
    Song * song = nil; 
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        song = [_filteredSongs objectAtIndex:indexPath.row];
    }
	else{
        song = [_songs objectAtIndex:indexPath.row];
    }
    
    
    [cell setSong:song];
    
    // set favorite icon
    
    cell.contentView.tag = song.identifier;
    

    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Song * song = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        song = [_filteredSongs objectAtIndex:indexPath.row];
    }
	else
	{
        song = [_songs objectAtIndex:indexPath.row];
    }
    
    
    if (song) {
        self.detailViewController.song = song;
        
    }
    
    
}



#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[_filteredSongs removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Song * fullSong in _songs)
	{
        
        NSRange result = NSMakeRange(NSNotFound, 0);
        NSRange result2 = result;
        NSRange result3 = result;
        if([scope isEqualToString:@"All"]){
            result = [fullSong.name rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            result2 = [fullSong.text rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            result3 = [fullSong.artist rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            
            if(result.location != NSNotFound || result2.location != NSNotFound || result3.location != NSNotFound){
                result.location  = 1;
            }
        }else if ([scope isEqualToString:@"Name"]) {
            result = [fullSong.name rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        }else if ([scope isEqualToString:@"Text"]) {
            result = [fullSong.text rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        }else if ([scope isEqualToString:@"Artist"]) {
            result = [fullSong.artist rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        }
        
        
        if (result.location != NSNotFound)
        {
            [_filteredSongs addObject:fullSong];
        }
	}
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

#pragma mark alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self startLoadSongs];
    }
}

#pragma mark api delegate

BOOL __firstLoad = YES;

-(void)getAllSongsFullDidLoad:(NSArray *)songs{
    [_songs removeAllObjects];
    
    [_songs addObjectsFromArray:songs];
    [_tableSongs reloadData];
    if(songs && songs.count > 0){
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%d songs loaded", songs.count]];

#ifdef HD_VERSION
        if(__firstLoad){
            __firstLoad = NO;
            self.detailViewController.song = [_songs objectAtIndex:0];
        }
#endif
    }
}



-(void)getSongsCountDidLoad:(NSNumber *)count{
    
    if(self != self.navigationController.topViewController) return;
    
    if([count intValue] > [_songs count]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Updates" message:@"New songs updates available! Do you want load them?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
        [alert show];
        [alert release];
    }
}


-(void)getAllSongsFullDidFail{
    [SVProgressHUD showErrorWithStatus:@"Server unavailable! Check your network connection and try again!" duration:1.8];
}





@end
