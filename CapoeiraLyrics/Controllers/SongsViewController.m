//
//  FirstViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongsViewController.h"
#import "AFJSONRequestOperation.h"




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
    
    [_songs release];
    _songs = nil;
    [_filteredSongs release];
    _filteredSongs = nil;


    [_tableSongs release];
    [super dealloc];
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    [self.searchDisplayController setActive:NO];
    [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:0];
    [_tableSongs setContentOffset:CGPointMake(0, 44)];
    

    
    NSURL *url = [NSURL URLWithString:@"http://capoeiralyrics.info/JSONAPI/AllSongsFull"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"http://capoeiralyrics.info/JSONAPI/AllSongsFull request JSON: %@", JSON );
        [_songs removeAllObjects];
        [_songs addObjectsFromArray:JSON];
        [_tableSongs reloadData];

    }
                                                                                        failure:nil];
    
    [operation start];
    
}

- (void)viewDidUnload
{


    [_tableSongs release];
    _tableSongs = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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


@end
