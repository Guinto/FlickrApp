//
//  PlaceAnnotation.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation

@synthesize place = _place;

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake([[self.place valueForKeyPath:@"latitude"] doubleValue], [[self.place valueForKeyPath:@"longitude"] doubleValue]);
}

- (NSString *)title
{
	return [self.place objectForKey:@"woe_name"];
}

- (NSString *)subtitle
{
	return [self.place objectForKey:@"_content"];
}

@end
