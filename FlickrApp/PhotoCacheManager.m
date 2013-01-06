//
//  PhotoCacheManager.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "PhotoCacheManager.h"

@implementation PhotoCacheManager

+ (void)cacheImage:(NSData *)photoData withPhotoInfo:(NSDictionary *)photoInfo
{
	NSFileManager *manager = [[NSFileManager alloc] init];
	NSURL *path = [[manager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *photoCache = [path URLByAppendingPathComponent:@"photoCache"];
	NSURL *photoPath = [photoCache URLByAppendingPathComponent:[photoInfo valueForKeyPath:FLICKR_PHOTO_ID]];
	
	NSArray *files = [manager contentsOfDirectoryAtURL:photoCache includingPropertiesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
	NSURL *oldestFile = [files lastObject];
	NSDate *oldestFileDate = nil;
	[oldestFile getResourceValue:&oldestFileDate forKey:NSURLCreationDateKey error:nil];
	NSInteger dirSize = 0;
	
	for (NSURL *file in files) {
		NSDate *fileDate = nil;
		[file getResourceValue:&fileDate forKey:NSURLCreationDateKey error:nil];
		if ([fileDate compare:oldestFileDate] == NSOrderedAscending) {
			oldestFile = file;
			oldestFileDate = fileDate;
		}
		dirSize += [[[manager attributesOfItemAtPath:[file path] error:nil] objectForKey:NSFileSize] integerValue];
	}
	
	NSNumber *dirMBSize = [NSNumber numberWithDouble:dirSize / 1048576.0];
	if ([dirMBSize doubleValue] >= 10) {
		[manager removeItemAtURL:oldestFile error:nil];
	}
	
	if ([manager createDirectoryAtURL:photoCache withIntermediateDirectories:YES attributes:nil error:nil]) {
		[photoData writeToURL:photoPath atomically:YES];
	}
}

+ (NSData *)getPhotoData:(NSDictionary *)photoInfo
{
	if (!photoInfo) {
		return nil;
	}
	NSFileManager *manager = [[NSFileManager alloc] init];
	NSURL *path = [[manager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *photoCache = [path URLByAppendingPathComponent:@"photoCache"];
	NSURL *photoPath = [photoCache URLByAppendingPathComponent:[photoInfo valueForKeyPath:FLICKR_PHOTO_ID]];
	
	if ([manager isReadableFileAtPath:[photoPath path]]) {
		return [NSData dataWithContentsOfURL:photoPath];
	}
	
	photoPath = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
	NSData *photoData = [NSData dataWithContentsOfURL:photoPath];
	[[self class] cacheImage:photoData withPhotoInfo:photoInfo];
	
	return photoData;
}

@end
