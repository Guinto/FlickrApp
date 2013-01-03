//
//  TopPlacesViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "PhotoInfoViewController.h"

@interface TopPlacesViewController ()

@property (nonatomic) NSDictionary *selectedPlace;
@property (nonatomic) NSArray *places;

@end

@implementation TopPlacesViewController

@synthesize places = _places;
@synthesize selectedPlace = _selectedPlace;

- (void)setPlaces:(NSArray *)places
{
	_places = places;
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	dispatch_queue_t downloadTopPlaces = dispatch_queue_create("topPlaces", NULL);
	dispatch_async(downloadTopPlaces, ^{
		NSArray *tempPlaces = [FlickrFetcher topPlaces];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.places = tempPlaces;
		});
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *place = (NSDictionary *)[self.places objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [place objectForKey:@"woe_name"];
	cell.detailTextLabel.text = [place objectForKey:@"_content"];
	
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[segue.destinationViewController setPlace:self.selectedPlace];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPlace = [self.places objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"showPhotoList" sender:self];
}

@end