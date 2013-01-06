//
//  PhotoAnnotation.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "PhotoAnnotation.h"

@implementation PhotoAnnotation

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake([[self.photo valueForKeyPath:@"latitude"] doubleValue], [[self.photo valueForKeyPath:@"longitude"] doubleValue]);

}

- (NSString *)title
{
	NSString *title = [self.photo valueForKeyPath:FLICKR_PHOTO_TITLE];
	if ([title isEqualToString:@""]) {
		title = [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
		if ([title isEqualToString:@""]) {
			title = @"Unknown";
		}
	}
	return title;
}

- (NSString *)subtitle
{
	return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

@end
