//
//  DPFlipsideViewController.m
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import "DPFlipsideViewController.h"

@interface DPFlipsideViewController ()

@end

@implementation DPFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
