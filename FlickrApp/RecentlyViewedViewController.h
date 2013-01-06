//
//  RecentlyViewedViewController.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoMapViewController.h"
#import "FlickrAPIKey.h"
#import "FlickrFetcher.h"

@interface RecentlyViewedViewController : UITableViewController

@property (nonatomic) NSArray *recentPhotoDetails;

@end
