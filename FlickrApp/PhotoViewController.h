//
//  PhotoViewController.h
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIScrollViewAccessibilityDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic) NSURL *photoURL;

@end
