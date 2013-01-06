//
//  PlacesMapViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "PlacesMapViewController.h"

@interface PlacesMapViewController ()
@property (nonatomic) NSDictionary *selectedPlace;
@end

@implementation PlacesMapViewController

@synthesize map = _map;
@synthesize selectedPlace = _selectedPlace;
@synthesize places = _places;

- (void)setPlaces:(NSArray *)places
{
	_places = places;
}

- (void)addAnnotations
{
	for (NSDictionary *place in self.places) {
		PlaceAnnotation *placeAnnotation = [[PlaceAnnotation alloc] init];
		placeAnnotation.place = place;
		[self.map addAnnotation:placeAnnotation];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.map.delegate = self;
	
	if (!self.places) {
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
		[self.view addSubview:spinner];
		[spinner startAnimating];
		
		dispatch_queue_t downloadTopPlaces = dispatch_queue_create("topPlaces", NULL);
		dispatch_async(downloadTopPlaces, ^{
			NSArray *tempPlaces = [FlickrFetcher topPlaces];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.places = tempPlaces;
				[spinner stopAnimating];
			});
		});
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[self addAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
	if (!aView) {
		aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
		aView.canShowCallout = YES;
		aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		aView.enabled = YES;
		
	}
	aView.annotation = annotation;
	// maybe load accessory views here (if not too expensive)?
	// or reset them and wait until mapView:didSelectAnnotationView: to load actual data
	return aView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showPhotoList"]) {
		[segue.destinationViewController setPlace:self.selectedPlace];
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	self.selectedPlace = ((PlaceAnnotation *)view.annotation).place;
	[self performSegueWithIdentifier:@"showPhotoList" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
