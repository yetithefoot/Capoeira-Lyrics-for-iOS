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




@implementation SongsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Songs", @"Songs");
#warning make retina icons
        self.tabBarItem.image = [UIImage imageNamed:@"note"];
        _songs = [[NSMutableArray alloc]init];
        _filteredSongs = [[NSMutableArray alloc] initWithCapacity:[_songs count]];
        
        
            
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
	
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableSongs.bounds.size.height, self.view.frame.size.width, _tableSongs.bounds.size.height)];
		view.delegate = self;
		[_tableSongs addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];

    
    [self.searchDisplayController setActive:NO];
    [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:0];
    [_tableSongs setContentOffset:CGPointMake(0, 44)];
    
    // show waiting hud
    [SVProgressHUD showWithStatus:@"Loading songs update..." maskType:SVProgressHUDMaskTypeBlack];
    // start load songs async
    [_api getAllSongsFull];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // select tabbar item "songs"
    // actually we need select item with name "songs"
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];
    
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

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    // show waiting hud
    [SVProgressHUD showWithStatus:@"Loading songs update..." maskType:SVProgressHUDMaskTypeBlack];
    // start load songs async
    [_api getAllSongsFull];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextAndImage"];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                 
                                       reuseIdentifier:@"TextAndImage"] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_pattern.png"]]autorelease];
        
    }
    
    NSString * song =  nil;
    NSString * artist = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        song = [[_filteredSongs objectAtIndex:indexPath.row] objectForKey:@"Name"];
        artist = [[_filteredSongs objectAtIndex:indexPath.row] objectForKey:@"Artist"];
    }
	else
	{
        song = [[_songs objectAtIndex:indexPath.row] objectForKey:@"Name"];
        artist = [[_songs objectAtIndex:indexPath.row] objectForKey:@"Artist"];
    }
    
    cell.textLabel.text = song;
    cell.detailTextLabel.text = artist;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * songDict;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        songDict = [_filteredSongs objectAtIndex:indexPath.row];
    }
	else
	{
        songDict = [_songs objectAtIndex:indexPath.row];
    }
    
    
    
    if (songDict) {
        Song * song = [Song songWithDictionary:songDict];
        DetailsViewController * detailsController = [[DetailsViewController alloc] initWithSong:song];

        [self.navigationController pushViewController: detailsController animated: YES];
        [detailsController release];

        
    }
}
#pragma mark UITabBar delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == [tabBar.items objectAtIndex:1]){
        
        UINavigationController * nav = self.navigationController;
        
        [nav popToRootViewControllerAnimated:NO];
        FavouritesViewController * controller = [[FavouritesViewController alloc] initWithNibName: @"FavouritesViewController" bundle: nil];
        [nav pushViewController: controller animated: YES];
        [controller release];
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
	for (id fullSong in _songs)
	{
        NSString * song =  [fullSong objectForKey:@"Name"];
        NSString * text =  [fullSong objectForKey:@"Text"];
        NSString * artist = [fullSong objectForKey:@"Artist"];
        
        NSRange result, result2, result3;
        if([scope isEqualToString:@"All"]){
            result = [song rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            result2 = [text rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            result3 = [artist rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            
            if(result.location != NSNotFound || result2.location != NSNotFound || result3.location != NSNotFound){
                result.location  = 1;
            }
        }else if ([scope isEqualToString:@"Name"]) {
            result = [song rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        }else if ([scope isEqualToString:@"Text"]) {
            result = [text rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        }else if ([scope isEqualToString:@"Artist"]) {
            result = [artist rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
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
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark api delegate

-(void)songsDidLoad:(NSArray *)songs{
    [_songs removeAllObjects];
    [_songs addObjectsFromArray:songs];
    [_tableSongs reloadData];
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
}

-(void)didFail{
    [SVProgressHUD showErrorWithStatus:@"Update failed! Try again later!"];
}



@end
