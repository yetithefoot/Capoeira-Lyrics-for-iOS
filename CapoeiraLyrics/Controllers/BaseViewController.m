//
//  BaseViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void) initialize{
    _api = [[CapoeiraLyricsAPI alloc]init];
    _api.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void) showAlertWithTitle: (NSString *) title andMessage: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:message
                                                   delegate:nil cancelButtonTitle:nil 
										  otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// hide navigation toolbar
    self.navigationController.navigationBarHidden = YES;
    
    
}

- (void) goBack: (id) sender {
	UINavigationController * navigationRoot = self.navigationController;
	[navigationRoot popViewControllerAnimated: true];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_api release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
