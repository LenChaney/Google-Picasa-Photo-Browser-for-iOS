//
//  DPMainViewController.m
//  PicasaBrower
//
//  Created by Dan Park on 1/24/13.
//  Copyright (c) 2013 Dan Park. All rights reserved.
//

#import "DPMainViewController.h"
#import "DPAlbumVC.h"

@interface DPMainViewController ()

@end

@implementation DPMainViewController
@synthesize albums;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [self setAlbums:array];
}


- (void)viewDidUnload
{
    [self setMAlbumTable:nil];
    [self setMUsernameField:nil];
    [self setMPasswordField:nil];
    [self setMAlbumProgressIndicator:nil];
    [self setMAlbumImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(DPFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    DPFlipsideViewController *controller = [[[DPFlipsideViewController alloc] initWithNibName:@"DPFlipsideViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (void)dealloc {
    [_mAlbumTable release];
    [_mUsernameField release];
    [_mPasswordField release];
    [_mAlbumProgressIndicator release];
    [_mAlbumImageView release];
    [super dealloc];
}



#pragma mark - UITableViewDelegate


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
    NSString *username = _mUsernameField.text;
    NSString *password = _mPasswordField.text;
    if ([username length] && [password length]) {
        [service setUserCredentialsWithUsername:username
                                       password:password];
    } else {
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }
    
    return service;
}

- (void)updateUI {
    
    // album list display
    [_mAlbumTable reloadData];
    
    if (mAlbumFetchTicket != nil) {
        [_mAlbumProgressIndicator startAnimating];
    } else {
        [_mAlbumProgressIndicator stopAnimating];
    }
}

#pragma mark Move a photo to another album

//- (void)moveSelectedPhotoToAlbum:(GDataEntryPhotoAlbum *)albumEntry {
//    
//    GDataEntryPhoto *photo = [self selectedPhoto];
//    if (photo) {
//        
//        NSString *destAlbumID = [albumEntry GPhotoID];
//        
//        // let the photo entry retain its target album ID as a property
//        // (since the contextInfo isn't retained)
//        [photo setProperty:destAlbumID forKey:kDestAlbumKey];
//        
//        // make the user confirm that the selected photo should be moved
//        NSBeginAlertSheet(@"Move Photo", @"Move", @"Cancel", nil,
//                          [self window], self,
//                          @selector(moveSheetDidEnd:returnCode:contextInfo:),
//                          nil, nil,
//                          @"Move the item \"%@\" to the album \"%@\"?",
//                          [[photo title] stringValue],
//                          [[albumEntry title] stringValue]);
//    }
//}

//static NSString* const kDestAlbumKey = @"DestAlbum";
//
//- (void)changeAlbumSelected:(id)sender {
//    // move the selected photo to the album represented by the sender menu item
//    NSMenuItem *menuItem = sender;
//    GDataEntryPhotoAlbum *albumEntry = [menuItem representedObject];
//    if (albumEntry) {
//        [self moveSelectedPhotoToAlbum:albumEntry];
//    }
//}

- (void)updateChangeAlbumList {
    
    // replace all menu items in the button with the titles and pointers
    // of the feed's entries, but preserve the title
    
//    NSString *title = [mChangeAlbumPopupButton title];
//    
//    NSMenu *menu = [[[NSMenu alloc] initWithTitle:title] autorelease];
//    [menu addItemWithTitle:title action:nil keyEquivalent:@""];
//    
//    [mChangeAlbumPopupButton setMenu:menu];
    
    GDataFeedPhotoUser *feed = [self albumFeed];
    
    for (GDataEntryPhotoAlbum *albumEntry in feed) {
        [albums addObject:albumEntry];
        
//        NSString *title = [[albumEntry title] stringValue];
//        NSMenuItem *item = [menu addItemWithTitle:title
//                                           action:@selector(changeAlbumSelected:)
//                                    keyEquivalent:@""];
//        [item setTarget:self];
//        [item setRepresentedObject:albumEntry];
    }
    
    [_mAlbumTable reloadData];
}

// album list fetch callback
- (void)albumListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoUser *)feed
                       error:(NSError *)error {
    [self setAlbumFeed:feed];
    [self setAlbumFetchError:error];
    [self setAlbumFetchTicket:nil];
    
    if (error == nil) {
        // load the Change Album pop-up button with the
        // album entries
        [self updateChangeAlbumList];
    }
    
    [self updateUI];
}

// begin retrieving the list of the user's albums
- (void)fetchAllAlbums {
    
    [self setAlbumFeed:nil];
    [self setAlbumFetchError:nil];
    [self setAlbumFetchTicket:nil];
    
    [self setPhotoFeed:nil];
    [self setPhotoFetchError:nil];
    [self setPhotoFetchTicket:nil];
    
    NSString *username = _mUsernameField.text;
    
    GDataServiceGooglePhotos *service = [self googlePhotosService];
    GDataServiceTicket *ticket;
    
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:username
                                                             albumID:nil
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    ticket = [service fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(albumListFetchTicket:finishedWithFeed:error:)];
    [self setAlbumFetchTicket:ticket];
    
    [self updateUI];
}

#pragma mark - VC functions

- (void)fetchURLString:(NSString*)urlString
          forImageView:(UIImageView*)view
                 title:(NSString*)title {
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];
    
    // use the fetcher's userData to remember which image view we'll display
    // this in once the fetch completes
    [fetcher setUserData:view];
    
    // http logs are more readable when fetchers have comments
    [fetcher setCommentWithFormat:@"thumbnail for %@", title];
    
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
}

// album and photo thumbnail display

// fetch or clear the thumbnail for this specified album
- (void)updateImageForAlbum:(GDataEntryPhotoAlbum *)album {
    
    // if there's a thumbnail and it's different from the one being shown,
    // fetch it now
    if (!album) {
        // clear the image
        [_mAlbumImageView setImage:nil];
        [self setAlbumImageURLString:nil];
        
    } else {
        // if the new thumbnail URL string is different from the previous one,
        // save the new one, clear the image and fetch the new image
        
        NSArray *thumbnails = [[album mediaGroup] mediaThumbnails];
        if ([thumbnails count] > 0) {
            
            NSString *imageURLString = [[thumbnails objectAtIndex:0] URLString];
            if (!imageURLString || ![mAlbumImageURLString isEqual:imageURLString]) {
                
                [self setAlbumImageURLString:imageURLString];
                [_mAlbumImageView setImage:nil];
                
                if (imageURLString) {
                    [self fetchURLString:imageURLString
                            forImageView:_mAlbumImageView
                                   title:[[album title] stringValue]];
                }
            } 
        }
    }
}

// get the album selected in the top list, or nil if none
- (GDataEntryPhotoAlbum *)selectedAlbum:(NSIndexPath*)indexPath {
    NSArray *albums = [mUserAlbumFeed entries];
    GDataEntryPhotoAlbum *album = [albums objectAtIndex:indexPath.row];
    return album;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *AlbumCellId = @"AlbumCellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:AlbumCellId] autorelease];
	}
    
    GDataEntryPhotoAlbum *albumEntry = [albums objectAtIndex:indexPath.row];
    
    NSString *title = [[albumEntry title] stringValue];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDataEntryPhotoAlbum *albumEntry = [albums objectAtIndex:indexPath.row];
    DPAlbumVC *vc = [[DPAlbumVC alloc] initWithNibName:@"DPAlbumVC" bundle:nil];
    [vc setUsername:_mUsernameField.text];
    [vc setPassword:_mPasswordField.text];
    [vc setAlbumEntry:albumEntry];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


#pragma mark - IBAction

- (IBAction)getAlbumClicked:(id)sender {
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *username = _mUsernameField.text;
    username = [username stringByTrimmingCharactersInSet:whitespace];
    
    if ([username rangeOfString:@"@"].location == NSNotFound) {
        // if no domain was supplied, add @gmail.com
        username = [username stringByAppendingString:@"@gmail.com"];
    }
    
    _mUsernameField.text = username;
    
    [self fetchAllAlbums];
}

@end
