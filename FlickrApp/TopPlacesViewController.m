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

@property (nonatomic) NSArray *selectedPlacePhotoDetails;

@end

@implementation TopPlacesViewController

@synthesize places = _places;
@synthesize selectedPlacePhotoDetails = _selectedPlacePhotoDetails;

- (NSArray *)places
{
	if (!_places) {
		_places = [FlickrFetcher topPlaces];
	}
	return _places;
}

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
	[segue.destinationViewController setPhotoDetails:self.selectedPlacePhotoDetails];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPlacePhotoDetails = [FlickrFetcher photosInPlace:[self.places objectAtIndex:indexPath.row] maxResults:50];
}

@end