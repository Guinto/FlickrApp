//
//  PhotoInfoViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "PhotoInfoViewController.h"
#import "PhotoViewController.h"

@interface PhotoInfoViewController ()

@property (nonatomic) NSURL *selectedPhotoURL;

@end

@implementation PhotoInfoViewController

@synthesize photoDetails = _photoDetails;
@synthesize selectedPhotoURL = _selectedPhotoURL;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *photoDetails = (NSDictionary *)[self.photoDetails objectAtIndex:indexPath.row];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[segue.destinationViewController setPhotoURL:self.selectedPhotoURL];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedPhotoURL = [FlickrFetcher urlForPhoto:[self.photoDetails objectAtIndex:indexPath.row] format:FlickrPhotoFormatOriginal];
	[self performSegueWithIdentifier:@"showPhoto" sender:self];
}

@end
