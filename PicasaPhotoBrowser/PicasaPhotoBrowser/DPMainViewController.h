//
//  DPMainViewController.h
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import "DPFlipsideViewController.h"
//#import <GDataPhoto/GData.h>
//#import <GDataPhoto/GDataFeedPhotoAlbum.h>
//#import <GDataPhoto/GDataFeedPhoto.h>
//#import <GDataPhoto/GDataServiceGooglePhotos.h>
//#import <GDataPhoto/GDataEntryPhoto.h>
//#import <GDataPhoto/GDataFeedPhoto.h>
//#import <GDataPhoto/GDataServiceGooglePhotos.h>
//#import <GDataPhoto/GTMHTTPFetcher.h>

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"
#import "GDataServiceGooglePhotos.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GTMHTTPFetcher.h"
#import "GDataServiceGooglePhotos.h"

@interface DPMainViewController : UIViewController
<DPFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    GDataFeedPhotoUser *mUserAlbumFeed; // user feed of album entries
    GDataServiceTicket *mAlbumFetchTicket;
    NSError *mAlbumFetchError;
    NSString *mAlbumImageURLString;
    
    GDataFeedPhotoAlbum *mAlbumPhotosFeed; // album feed of photo entries
    GDataServiceTicket *mPhotosFetchTicket;
    NSError *mPhotosFetchError;
    NSString *mPhotoImageURLString;
    NSMutableArray *albums;
}
@property (retain, nonatomic) NSMutableArray *albums;


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mAlbumProgressIndicator;
@property (retain, nonatomic) IBOutlet UITableView *mAlbumTable;
@property (retain, nonatomic) IBOutlet UITextField *mUsernameField;
@property (retain, nonatomic) IBOutlet UITextField *mPasswordField;
@property (retain, nonatomic) IBOutlet UIImageView *mAlbumImageView;

- (IBAction)showInfo:(id)sender;

@end
