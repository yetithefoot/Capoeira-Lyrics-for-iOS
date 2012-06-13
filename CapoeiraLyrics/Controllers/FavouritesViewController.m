//
//  FavouritesViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavouritesViewController.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Favorites", @"Favorites");
        self.tabBarItem.image = [UIImage imageNamed:@"star"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.hidesBackButton = YES;
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // select tabbar item "Favourites"
    // actually we need select item with name "Favourites"
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:1]];
}

- (void)viewDidUnload
{
    [_tabBar release];
    _tabBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark UITabBar delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == [tabBar.items objectAtIndex:0]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)dealloc {
    [_tabBar release];
    [super dealloc];
}
@end
