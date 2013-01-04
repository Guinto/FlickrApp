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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (!self.photoURL) {
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
		[self.view addSubview:spinner];
		[spinner startAnimating];
		
		dispatch_queue_t downloadPhotoURL = dispatch_queue_create("downloadPhotoURL", NULL);
		dispatch_async(downloadPhotoURL, ^{
			NSURL *tempPhotoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.photoURL = tempPhotoURL;
				[self setImage];
				[spinner stopAnimating];
			});
		});
	}
}

- (void)setImage
{
	UIImage *photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	
	self.photoView = [[UIImageView alloc] initWithImage:photoImage];
	
	[self.scrollView addSubview:self.photoView];
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
