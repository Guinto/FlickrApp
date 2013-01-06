//
//  PhotoAnnotation.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"

@interface PhotoAnnotation : NSObject <MKAnnotation>
@property (nonatomic) NSDictionary *photo;
@end
