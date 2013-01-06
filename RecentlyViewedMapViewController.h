//
//  RecentlyViewedMapViewController.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"
#import "PhotoAnnotation.h"

@interface RecentlyViewedMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic) NSArray *recentPhotoDetails;

@end
