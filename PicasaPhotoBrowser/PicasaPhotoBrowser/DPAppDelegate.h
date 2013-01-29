//
//  DPAppDelegate.h
//  PicasaPhotoBrowser
//
//  Created by Dan Park on 1/28/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
