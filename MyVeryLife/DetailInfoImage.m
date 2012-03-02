//
//  DetailInfoImage.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailInfoImage.h"
#import "UIImageView+WebCache.h"

@implementation DetailInfoImage

@synthesize imageView;
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];

    CGRect oriFrame = self.imageView.frame;
    CGRect frame = self.imageView.frame;

    double ratio = 1.0;
    double ratioH = frame.size.height/self.imageView.image.size.height;
    double ratioW = frame.size.width/self.imageView.image.size.width;
    ratio = ratioH<ratioW?ratioH:ratioW;
    ratioH = ratio;
    ratioW = ratio;
    
    
    frame.size.width = self.imageView.image.size.width * ratioW;
    frame.size.height = self.imageView.image.size.height * ratioH;
    
    frame.origin.x += (oriFrame.size.width - frame.size.width)/2;
    frame.origin.y += (oriFrame.size.height - frame.size.height)/2;
    
    self.imageView.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
