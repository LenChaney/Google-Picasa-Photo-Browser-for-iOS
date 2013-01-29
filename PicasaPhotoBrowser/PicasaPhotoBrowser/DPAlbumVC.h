//
//  DPAlbumVC.h
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"
#import "GDataServiceGooglePhotos.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GTMHTTPFetcher.h"
#import "GDataServiceGooglePhotos.h"

//#import <GDataPhoto/GData.h>
//#import <GDataPhoto/GDataFeedPhotoAlbum.h>
//#import <GDataPhoto/GDataFeedPhoto.h>
//#import <GDataPhoto/GDataServiceGooglePhotos.h>
//#import <GDataPhoto/GDataEntryPhoto.h>
//#import <GDataPhoto/GDataFeedPhoto.h>
//#import <GDataPhoto/GDataServiceGooglePhotos.h>
//#import <GDataPhoto/GTMHTTPFetcher.h>


@interface DPAlbumVC : UIViewController
<UITableViewDataSource, UITableViewDelegate> {
    
    GDataFeedPhotoUser *mUserAlbumFeed; // user feed of album entries
    GDataServiceTicket *mAlbumFetchTicket;
    NSError *mAlbumFetchError;
    NSString *mAlbumImageURLString;
    
    GDataFeedPhotoAlbum *mAlbumPhotosFeed; // album feed of photo entries
    GDataServiceTicket *mPhotosFetchTicket;
    NSError *mPhotosFetchError;
    NSString *mPhotoImageURLString;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityWindow;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) NSMutableArray *photos;
@property (retain, nonatomic) GDataEntryPhotoAlbum *albumEntry;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;


@end
