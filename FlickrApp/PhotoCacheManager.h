//
//  PhotoCacheManager.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 1/5/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrFetcher.h"

@interface PhotoCacheManager : NSObject

+ (void)cacheImage:(NSData *)photoData withPhotoInfo:(NSDictionary *)photoInfo;
+ (NSData *)getPhotoData:(NSDictionary *)photoInfo;

@end
