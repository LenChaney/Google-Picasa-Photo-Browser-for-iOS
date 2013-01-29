//
//  DPAlbumVC.m
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import "DPAlbumVC.h"

@interface DPAlbumVC ()

@end

@implementation DPAlbumVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchSelectedAlbum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_imageView release];
    [_activityWindow release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setImageView:nil];
    [self setActivityWindow:nil];
    [super viewDidUnload];
}

#pragma mark - Picasa Accessors

- (GDataFeedPhotoUser *)albumFeed {
    return mUserAlbumFeed;
}

- (void)setAlbumFeed:(GDataFeedPhotoUser *)feed {
    [mUserAlbumFeed autorelease];
    mUserAlbumFeed = [feed retain];
}

- (NSError *)albumFetchError {
    return mAlbumFetchError;
}

- (void)setAlbumFetchError:(NSError *)error {
    [mAlbumFetchError release];
    mAlbumFetchError = [error retain];
}

- (GDataServiceTicket *)albumFetchTicket {
    return mAlbumFetchTicket;
}

- (void)setAlbumFetchTicket:(GDataServiceTicket *)ticket {
    [mAlbumFetchTicket release];
    mAlbumFetchTicket = [ticket retain];
}

- (NSString *)albumImageURLString {
    return mAlbumImageURLString;
}

- (void)setAlbumImageURLString:(NSString *)str {
    [mAlbumImageURLString autorelease];
    mAlbumImageURLString = [str copy];
}

- (GDataFeedPhotoAlbum *)photoFeed {
    return mAlbumPhotosFeed;
}

- (void)setPhotoFeed:(GDataFeedPhotoAlbum *)feed {
    [mAlbumPhotosFeed autorelease];
    mAlbumPhotosFeed = [feed retain];
}

- (NSError *)photoFetchError {
    return mPhotosFetchError;
}

- (void)setPhotoFetchError:(NSError *)error {
    [mPhotosFetchError release];
    mPhotosFetchError = [error retain];
}

- (GDataServiceTicket *)photoFetchTicket {
    return mPhotosFetchTicket;
}

- (void)setPhotoFetchTicket:(GDataServiceTicket *)ticket {
    [mPhotosFetchTicket release];
    mPhotosFetchTicket = [ticket retain];
}

- (NSString *)photoImageURLString {
    return mPhotoImageURLString;
}

- (void)setPhotoImageURLString:(NSString *)str {
    [mPhotoImageURLString autorelease];
    mPhotoImageURLString = [str copy];
}

#pragma mark - GData Services


- (GDataServiceGooglePhotos *)googlePhotosService {
    
    static GDataServiceGooglePhotos* service = nil;
    
    if (!service) {
        service = [[GDataServiceGooglePhotos alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    if ([_username length] && [_password length]) {
        [service setUserCredentialsWithUsername:_username
                                       password:_password];
    } else {
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }
    
    return service;
}


#pragma mark Fetch an album's photos



// album and photo thumbnail display

// fetch or clear the thumbnail for this specified album
- (void)updateImageForAlbum:(GDataEntryPhotoAlbum *)album {
    
    // if there's a thumbnail and it's different from the one being shown,
    // fetch it now
    if (!album) {
        // clear the image
        [_imageView setImage:nil];
        [self setAlbumImageURLString:nil];
        
    } else {
        // if the new thumbnail URL string is different from the previous one,
        // save the new one, clear the image and fetch the new image
        
        NSArray *thumbnails = [[album mediaGroup] mediaThumbnails];
        if ([thumbnails count] > 0) {
            
            NSString *imageURLString = [[thumbnails objectAtIndex:0] URLString];
            if (!imageURLString || ![mAlbumImageURLString isEqual:imageURLString]) {
                
                [self setAlbumImageURLString:imageURLString];
                [_imageView setImage:nil];
                
                if (imageURLString) {
                    [self fetchURLString:imageURLString
                            forImageView:_imageView
                                   title:[[album title] stringValue]];
                }
            } 
        }
    }
}


- (void)updateUI {
    if (mAlbumFetchTicket != nil) {
        [_activityWindow startAnimating];
    } else {
        [_activityWindow stopAnimating];
    }
}

// photo list fetch callback
- (void)photosTicket:(GDataServiceTicket *)ticket
    finishedWithFeed:(GDataFeedPhotoAlbum *)feed
               error:(NSError *)error {

    [self setPhotoFeed:feed];
    [self setPhotoFetchError:error];
    [self setPhotoFetchTicket:nil];

    NSArray *entries = [mAlbumPhotosFeed entries];
    [self setPhotos:[entries mutableCopy]];
    [_tableView reloadData];
    
    [self updateUI];
}

// for the album selected in the top list, begin retrieving the list of
// photos
- (void)fetchSelectedAlbum {
    if (_albumEntry) {
        // fetch the photos feed
        NSURL *feedURL = [[_albumEntry feedLink] URL];
        if (feedURL) {
            [self setPhotoFeed:nil];
            [self setPhotoFetchError:nil];
            [self setPhotoFetchTicket:nil];
            
            GDataServiceGooglePhotos *service = [self googlePhotosService];
            GDataServiceTicket *ticket;
            ticket = [service fetchFeedWithURL:feedURL
                                      delegate:self
                             didFinishSelector:@selector(photosTicket:finishedWithFeed:error:)];
            [self setPhotoFetchTicket:ticket];
            
            [self updateUI];
        }
    }
}


- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    if (error == nil) {
        // got the data; display it in the image view
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        UIImageView *view = (UIImageView *)[fetcher userData];
        [view setImage:image];
    } else {
        NSLog(@"imageFetcher:%@ error:%@", fetcher,  error);
    }
}

- (void)fetchURLString:(NSString *)urlString
          forImageView:(UIImageView *)view
                 title:(NSString *)title {
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];
    
    // use the fetcher's userData to remember which image view we'll display
    // this in once the fetch completes
    [fetcher setUserData:view];
    
    // http logs are more readable when fetchers have comments
    [fetcher setCommentWithFormat:@"thumbnail for %@", title];
    
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
}


// get or clear the thumbnail for this specified photo
- (void)updateImageForPhoto:(GDataEntryPhoto *)photo {
    
    // if there's a thumbnail and it's different from the one being shown,
    // fetch it now
    if (!photo) {
        // clear the image
        [_imageView setImage:nil];
        [self setPhotoImageURLString:nil];
        
    } else {
        // if the new thumbnail URL string is different from the previous one,
        // save the new one, clear the image and fetch the new image
        
        NSArray *thumbnails = [[photo mediaGroup] mediaThumbnails];
        if ([thumbnails count] > 0) {
            
            NSString *imageURLString = [[thumbnails objectAtIndex:0] URLString];
            if (!imageURLString || ![mPhotoImageURLString isEqual:imageURLString]) {
                
                [self setPhotoImageURLString:imageURLString];
                [_imageView setImage:nil];
                
                if (imageURLString) {
                    [self fetchURLString:imageURLString
                            forImageView:_imageView
                                   title:[[photo title] stringValue]];
                }
            } 
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *AlbumCellId = @"PhotoCellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:AlbumCellId] autorelease];
        
    }
    
    GDataEntryPhoto *photo = [_photos objectAtIndex:indexPath.row];
    NSString *title = [[photo title] stringValue];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDataEntryPhoto *photo = [_photos objectAtIndex:indexPath.row];
    if (photo) {
        [self updateImageForPhoto:photo];
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - IBAction
- (IBAction)fetchPhotos:(id)sender {
    [self fetchSelectedAlbum];
}

@end
