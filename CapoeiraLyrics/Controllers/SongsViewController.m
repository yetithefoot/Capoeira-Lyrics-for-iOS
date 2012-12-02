//
//  FirstViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongsViewController.h"
#import "AFJSONRequestOperation.h"


#import "DetailsViewController.h"
#import "FavouritesViewController.h"


#import "SongTableViewCell.h"

#import "PrivateConstants.h"




@implementation SongsViewController


#pragma mark api

-(void) startLoadSongs{
    // show waiting hud
    [SVProgressHUD showWithStatus:@"Loading songs update..." maskType:SVProgressHUDMaskTypeBlack];
    // start load songs async
    [_api getAllSongsFull];
}




#pragma mark lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Songs", @"Songs");
#warning make retina icons
        self.tabBarItem.image = [UIImage imageNamed:@"black_heart"];
        _songs = [[NSMutableArray alloc]init];
        _filteredSongs = [[NSMutableArray alloc] init];
        
        
            
    }
    return self;
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
	
#ifdef LITE_VERSION
    {
        mBannerView = [[SOMABannerView alloc] initWithDimension:kSOMAAdDimensionDefault]; 
        mBannerView.frame = CGRectMake(0, 361, 320, 50);
        [mBannerView adSettings].adspaceId = [PrivateConstants smaatoAdSpace1];
        [mBannerView adSettings].publisherId = [PrivateConstants smaatoPublisherId]; 
        [mBannerView addAdListener:self];
                
        [self.view addSubview:mBannerView];
        [mBannerView release];
    }
#endif
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableSongs.bounds.size.height, self.view.frame.size.width, _tableSongs.bounds.size.height)arrowImageName:@"grayArrow.png" textColor:[UIColor lightGrayColor]];

		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];

		[_tableSongs addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    
    // tune index view
    CGRect rect = CGRectMake(self.view.frame.size.width-34, 82.0, 28.0, [[UIScreen mainScreen] bounds].size.height-156);
    
    _indexBar = [[CMIndexBar alloc] initWithFrame:rect];

    NSMutableArray * indexes = [NSMutableArray arrayWithArray:[NSArray arrayWithAlphaNumericTitles]];
    [indexes removeLastObject];
    [_indexBar setIndexes:indexes];
    [self.view addSubview:_indexBar];
    _indexBar.delegate = self;


    
    
	
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
    
#ifdef LITE_VERSION
    {
        [mBannerView setAutoReloadEnabled:YES]; 
        [mBannerView asyncLoadNewBanner];
    }
#endif
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#ifdef LITE_VERSION
    {
        [mBannerView setAutoReloadEnabled:NO]; 
    }
#endif
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

-(CGRect) infoButtonRect{
    return CGRectZero;
}

#pragma mark -
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

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

int __lastClickedCell = -1;

-(void) makeFavorite:(id) sender{
    Song * song = [Song  getSongByIdentifier:__lastClickedCell inArray:_songs];
    
    if(song){
        BOOL isFavorite = song.favorite;
        song.favorite = !isFavorite;
        
        [_tableSongs reloadData]; //reload main table
        [self.searchDisplayController.searchResultsTableView reloadData]; //reload table under search context (All, Text, Name, Artist etc.)
    }    
    
}

-(void) openVideo:(id) sender{
    
    Song * song = [Song  getSongByIdentifier:__lastClickedCell inArray:_songs];
    
    [song openVideo];
}


-(void)cellLongPressed :(UILongPressGestureRecognizer *) sender
{
    if(sender.state == UIGestureRecognizerStateBegan){
        
        Song * song = [Song  getSongByIdentifier:sender.view.tag inArray:_songs];
        
        if(song){
            __lastClickedCell = sender.view.tag;
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
}

#pragma tableview datasource + delegate



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return nil;        
}

- (void)indexSelectionDidChange:(CMIndexBar *)IndexBar:(int)index:(NSString*)title{

    index--;
    
        NSString * letter = [[NSArray arrayWithAlphaNumericTitles] objectAtIndex:index];
        NSIndexSet * indexSet = [_songs indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                                 {
                                     Song *song = (Song *)obj;
                                     if ([song.name hasPrefix:letter]) {
                                         *stop = YES;
                                         return YES;
                                     }
                                     return NO;
                                 }];
        
        // scroll to rigth position
        if(indexSet.count == 0){

        }
        else
            /*if([indexSet firstIndex] == 0) {
                [_tableSongs scrollsToTop];
                
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                hud.mode = MBProgressHUDModeText;
                hud.animationType = MBProgressHUDAnimationFade;
                hud.labelText = @"A";
                [hud show:YES];
                [hud hide:YES afterDelay:0.7];
                
                
            }else*/{
                [_tableSongs scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexSet firstIndex] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                hud.mode = MBProgressHUDModeText;
                hud.animationType = MBProgressHUDAnimationFade;
                hud.labelText = letter;
                [hud show:YES];
                [hud hide:YES afterDelay:0.7];
            }
        

        
    
}





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
    CGRect rect = cell.frame;
    rect.size.width = 320;
    cell.frame = rect;
    
    // set favorite icon

    cell.contentView.tag = song.identifier;
    
    UILongPressGestureRecognizer *longpressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
    [cell.contentView addGestureRecognizer:longpressed];   
    [longpressed release];
    
    
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
        DetailsViewController * detailsController = [[DetailsViewController alloc] initWithSong:song andHideBackButton:NO];
        
        [self.navigationController pushViewController: detailsController animated: YES];
        [detailsController release];
        
    }

}
#pragma mark UITabBar delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == [tabBar.items objectAtIndex:1]){
        
        NSArray * favedSongs = [Song filterOnlyFavorites:_songs];
        
        if([favedSongs count] > 0){
            UINavigationController * nav = self.navigationController;
            [nav popToRootViewControllerAnimated:NO];
        
            FavouritesViewController * controller = [[FavouritesViewController alloc] initWithArray:favedSongs];
            [nav pushViewController: controller animated: YES];
            [controller release];
        }else{
            [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString( @"You have no favorite songs. Check any and try again!", @"") duration:1.5];
        }
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

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    _indexBar.hidden = YES;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    _indexBar.hidden = NO;
}

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




-(void)getAllSongsFullDidLoad:(NSArray *)songs{
    [_songs removeAllObjects];
    
    [_songs addObjectsFromArray:songs];
    [_tableSongs reloadData];
    if(songs && [songs count] > 0){
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%d songs loaded!", [songs count]]];
        

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

#pragma mark AdListenerProtocol 
#ifdef LITE_VERSION
-(void)onReceiveAd:(id<SOMAAdDownloaderProtocol>)sender withReceivedBanner:(id<SOMAReceivedBannerProtocol>)receivedBanner
{
    // disable scrolltotop and bouncing for banner view
    if(sender && [sender isKindOfClass:[SOMABannerView class]]){
        [self disableScrollsToTopPropertyOnAllSubviewsOf:(SOMABannerView *)sender];
    }
}
#endif




@end
