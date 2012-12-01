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

- (void) disableScrollsToTopPropertyOnAllSubviewsOf:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).scrollsToTop = NO;
            ((UIScrollView *)subview).bounces = NO;
        }
        [self disableScrollsToTopPropertyOnAllSubviewsOf:subview];
    }
}


// overridable method
-(BOOL) shouldShowInfoButton{
    return YES;
}

// overridable method
- (void)presentInfo
{
    [SVProgressHUD showSuccessWithStatus:[self copyrightText] duration:4];
}

// overridable method
-(NSString *) copyrightText{
    return @"Lyrics are the property and copyright of their respective owners.\r\n\r\nLyrics provided for educational purposes and personal use only.";
}


-(CGRect) infoButtonRect{
    return CGRectMake(self.view.bounds.size.width - 40,
                      self.view.bounds.size.height - 90,
                      40,
                      40);
}

// overridable method
- (void)viewDidLoad
{
    [super viewDidLoad];
	// hide navigation toolbar
    self.navigationController.navigationBarHidden = YES;
    
    if([self shouldShowInfoButton]){
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        infoButton.frame = [self infoButtonRect];
        infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:infoButton];
    }
    
    
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
