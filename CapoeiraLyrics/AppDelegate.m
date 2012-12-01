//
//  AppDelegate.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "SongsViewController.h"
#import "DetailsViewController.h"
#import "FavouritesViewController.h"

#import "SHK.h"
#import "SHKFacebook.h"
#import "SHKConfiguration.h"
#import "CapoeiraLyricsSHKConfigurator.h"



#ifdef HD_VERSION

#import "HDMasterViewController.h"


#endif

#import <FlurrySDK/Flurry.h>
#import "PrivateConstants.h"


@implementation AppDelegate

@synthesize window = _window;


- (void)dealloc
{
    [_window release];
    [_navigationRoot release];
    [super dealloc];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [SHKFacebook handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication 
        annotation:(id)annotation{
    return [SHKFacebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // integrate Flurry SDK
    [Flurry startSession:[PrivateConstants flurryAppKey]];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
#ifdef HD_VERSION
    
    HDMasterViewController *masterViewController = [[HDMasterViewController alloc] initWithNibName:@"HDMasterViewController" bundle:nil];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    DetailsViewController * detailViewController= [[DetailsViewController alloc]initWithSong:[Song fakeSong] andHideBackButton:YES];

    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    masterViewController.detailViewController = detailViewController;
    
    UISplitViewController * splitViewController = [[UISplitViewController alloc] init];
    //splitViewController.delegate = detailViewController;
    splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
    self.window.rootViewController = splitViewController;

    
#else
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[SongsViewController alloc] initWithNibName:@"SongsViewController" bundle:nil] autorelease];
    _navigationRoot = [[UINavigationController alloc]initWithRootViewController:viewController1];
    self.window.rootViewController = _navigationRoot;
    
    
#endif
    
    
    
    
    
    
    
    [self.window makeKeyAndVisible];
    
    // colorize elements
    if ([[UIView class] respondsToSelector:@selector(appearance)]) {
        //UIColor * mainTintColor = [UIColor colorWithRed:0.0915 green:0.4354 blue:0.2077 alpha:1.0000];
        UIColor * mainTintColor = [UIColor darkGrayColor];
        [[UINavigationBar appearance] setTintColor:mainTintColor];   
        [[UITabBar appearance] setTintColor:mainTintColor];
        [[UIToolbar appearance] setTintColor:mainTintColor];
        [[UISearchBar appearance] setTintColor:mainTintColor];
    }
    
    //[[UITableView appearance] setSeparatorColor:[UIColor colorWithRed:0.9935 green:0.7753 blue:0.1646 alpha:1.0000]];
    //[[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setColor:[UIColor colorWithRed:0.1842 green:0.1728 blue:0.5107 alpha:1.0000]];
    
    
    // initialize share kit
    DefaultSHKConfigurator *configurator = [[CapoeiraLyricsSHKConfigurator alloc] init];

    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [Configuration saveSettings];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Configuration saveSettings];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
