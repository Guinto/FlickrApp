//
//  PhotoViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (nonatomic) UIImageView *photoView;
@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize photoView = _photoView;
@synthesize photoURL = _photoURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (!self.photoURL) {
		self.navigationController.title	= @"No Image URL Found";
	}
	UIImage *photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	
	self.photoView = [[UIImageView alloc] initWithImage:photoImage];
	[self.photoView setContentMode:UIViewContentModeScaleAspectFill];
	
	[self.scrollView addSubview:self.photoView];
	
	self.scrollView.frame = CGRectMake(0, 0, self.photoView.frame.size.width, self.photoView.frame.size.height);
	[self.scrollView setContentSize:CGSizeMake(self.photoView.frame.size.width, self.photoView.frame.size.height)];
	self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.photoView;
}

@end
