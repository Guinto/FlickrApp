//
//  RecentlyViewedMapViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "RecentlyViewedMapViewController.h"
#import "PhotoViewController.h"

@interface RecentlyViewedMapViewController ()

@property (nonatomic) NSDictionary *selectedPhoto;

@end

@implementation RecentlyViewedMapViewController

@synthesize selectedPhoto = _selectedPhoto;
@synthesize map = _map;
@synthesize recentPhotoDetails = _recentPhotoDetails;

- (void)addAnnotations
{
	for (NSDictionary *photo in self.recentPhotoDetails) {
		PhotoAnnotation *photoAnnotation = [[PhotoAnnotation alloc] init];
		photoAnnotation.photo = photo;
		[self.map addAnnotation:photoAnnotation];
	}
	[self zoomToFitMapAnnotations];
}

- (void)zoomToFitMapAnnotations
{
	if ([self.map.annotations count] == 0) return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(id<MKAnnotation> annotation in self.map.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
	
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
	
    region = [self.map regionThatFits:region];
    [self.map setRegion:region animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.map.delegate = self;
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
		aView.leftCalloutAccessoryView = [[UIImageView alloc] init];
		aView.enabled = YES;
		
	}
	aView.annotation = annotation;
	// maybe load accessory views here (if not too expensive)?
	// or reset them and wait until mapView:didSelectAnnotationView: to load actual data
	return aView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showPhoto"]) {
		[segue.destinationViewController setPhoto:self.selectedPhoto];
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	self.selectedPhoto = ((PhotoAnnotation *)view.annotation).photo;
	
	if (self.splitViewController) {
		PhotoViewController *detailViewController = [[self.splitViewController childViewControllers] lastObject];
		[detailViewController setPhoto:self.selectedPhoto];
	} else {
		[self performSegueWithIdentifier:@"showPhoto" sender:nil];
	}
	
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
		UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
		
		if ([view.annotation isKindOfClass:[PhotoAnnotation class]]) {
			PhotoAnnotation *photoAnnotation = (PhotoAnnotation*)view.annotation;
			imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
			dispatch_queue_t downloadThumbnail = dispatch_queue_create("downloadThumbnail", nil);
			dispatch_async(downloadThumbnail, ^{
				UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photoAnnotation.photo format:FlickrPhotoFormatSquare]]];
				dispatch_async(dispatch_get_main_queue(), ^{
					imageView.image = tempImage;
				});
			});
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
