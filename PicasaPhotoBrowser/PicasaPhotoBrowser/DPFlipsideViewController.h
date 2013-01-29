//
//  DPFlipsideViewController.h
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPFlipsideViewController;

@protocol DPFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(DPFlipsideViewController *)controller;
@end

@interface DPFlipsideViewController : UIViewController

@property (assign, nonatomic) id <DPFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
