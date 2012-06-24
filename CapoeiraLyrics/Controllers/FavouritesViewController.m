//
//  FavouritesViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavouritesViewController.h"
#import "DetailsViewController.h"
#import "SongTableViewCell.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

- (id)initWithArray:(NSArray *) aSongs
{
    self = [self initWithNibName:@"FavouritesViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Favorites", @"Favorites");
        self.tabBarItem.image = [UIImage imageNamed:@"black_heart"];
        
        _songs = [[NSMutableArray alloc]initWithArray:aSongs];
        _filteredSongs = [[NSMutableArray alloc] init];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchDisplayController setActive:NO];
    [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:0];
    // hide searchbar
    //[_tableSongs setContentOffset:CGPointMake(0, 44)];
	
    self.navigationItem.hidesBackButton = YES;
     

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // select tabbar item "Favourites"
    // actually we need select item with name "Favourites"
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:1]];
    
    // remove all non favorite items from songs arrays
    for (Song * song in _songs) {
        if(!song.isFavorite)
            [_songs removeObject:song];
    }
    
    for (Song * song in _filteredSongs) {
        if(!song.isFavorite)
            [_filteredSongs removeObject:song];
    }
    
    
    [_tableSongs reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];

}


- (void)viewDidUnload
{
    [_tabBar release];
    _tabBar = nil;
    [_tableSongs release];
    _tableSongs = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


#pragma mark UITabBar delegate


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == [tabBar.items objectAtIndex:0]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark table view delegate

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
    /*if(song.favorite){
     cell.imageView.image = [UIImage imageNamed:@"star_enabled.png"];
     }else{
     cell.imageView.image = [UIImage imageNamed:@"star_disabled.png"];
     }
     
     cell.imageView.userInteractionEnabled = YES;
     cell.imageView.tag = song.identifier;
     
     UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
     tapped.numberOfTapsRequired = 1;
     [cell.imageView addGestureRecognizer:tapped];   
     [tapped release];
     */
    
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
        DetailsViewController * detailsController = [[DetailsViewController alloc] initWithSong:song];
        
        [self.navigationController pushViewController: detailsController animated: YES];
        [detailsController release];
        
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
        
        NSRange result, result2, result3;
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


- (void)dealloc {
    [_songs release];
    [_filteredSongs release];
    [_tabBar release];
    [_tableSongs release];
    [super dealloc];
}
@end
