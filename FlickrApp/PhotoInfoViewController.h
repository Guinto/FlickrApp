//
//  PhotoInfoViewController.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrAPIKey.h"
#import "FlickrFetcher.h"

@interface PhotoInfoViewController : UITableViewController

@property (nonatomic) NSDictionary *place;

@end
