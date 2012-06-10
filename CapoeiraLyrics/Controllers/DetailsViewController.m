//
//  DetailsViewController.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController


- (id)initWithSong:(Song *)song
{
    self = [super initWithNibName:@"DetailsViewController" bundle:nil];
    if (self) {
        _song = [song retain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _labelTitle.text = _song.name;
    _labelText.text = _song.text;
    self.navigationItem.title = _song.name;
#warning get code from todotogo for details scroll view for text
#warning add tags section and set favorite button
}

- (void)viewDidUnload
{
    [_labelTitle release];
    _labelTitle = nil;
    [_labelText release];
    _labelText = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_labelTitle release];
    [_labelText release];
    [_song release];
    [super dealloc];
}
@end
