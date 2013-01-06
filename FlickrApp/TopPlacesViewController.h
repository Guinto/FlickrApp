//
//  TopPlacesViewController.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesMapViewController.h"
#import "FlickrAPIKey.h"
#import "FlickrFetcher.h"

@interface TopPlacesViewController : UITableViewController

@property (nonatomic, readonly) NSArray *places;

@end
