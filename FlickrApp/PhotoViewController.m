//
//  PhotoViewController.m
//  FlickrApp
//
//  Created by Trent Ellingsen on 12/4/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController ()
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) NSURL *photoURL;
@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize photoView = _photoView;
@synthesize photoURL = _photoURL;
@synthesize photo = _photo;

- (void)setPhotoURL:(NSURL *)photoURL
{
	if (_photoURL != photoURL) {
		_photoURL = photoURL;
		[self setImage];
	}
}

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
		dispatch_queue_t downloadPhotoURL = dispatch_queue_create("downloadPhotoURL", NULL);
		dispatch_async(downloadPhotoURL, ^{
			NSURL *tempPhotoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.photoURL = tempPhotoURL;
			});
		});
	}
}

- (void)setImage
{
	UIImage *photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	
	self.photoView = [[UIImageView alloc] initWithImage:photoImage];
	
	[self.photoView setContentMode:UIViewContentModeScaleToFill];
	self.photoView.frame = CGRectMake(0, 0, self.photoView.bounds.size.width, self.photoView.bounds.size.height);
	
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
