//
//  RecentlyViewedViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "RecentlyViewedViewController.h"
#import "PhotoViewController.h"

@interface RecentlyViewedViewController ()

@property (nonatomic) NSDictionary *selectedPhoto;

@end

@implementation RecentlyViewedViewController

@synthesize recentPhotoDetails = _recentPhotoDetails;
@synthesize selectedPhoto = _selectedPhoto;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.recentPhotoDetails = [defaults arrayForKey:@"recentPhotos"];
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[segue.destinationViewController setPhoto:self.selectedPhoto];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPhotoDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *photoDetails = (NSDictionary *)[self.recentPhotoDetails objectAtIndex:indexPath.row];
	NSString *title = [photoDetails valueForKeyPath:FLICKR_PHOTO_TITLE];
	NSString *description = [photoDetails valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
	if ([title isEqualToString:@""]) {
		title = [photoDetails valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
		if ([title isEqualToString:@""]) {
			title = @"Unknown";
		}
	}
	
	cell.textLabel.text = title;
	cell.detailTextLabel.text = description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *photo = [self.recentPhotoDetails objectAtIndex:indexPath.row];
	self.selectedPhoto = photo;
	[self performSegueWithIdentifier:@"showPhoto" sender:self];
}

@end
