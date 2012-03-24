//
//  StartViewController.m
//  MyVeryLife
//
//  Created by Rock on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"

@implementation StartViewController
@synthesize status;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self start];
}

-(void)start
{
    //check netwok
    BOOL connected = [Utility connectedToNetwork];
    
    if (!connected) {
        self.status.text = @"亲，好像网络有问题哦～～～";
        [self performSelector:@selector(start) withObject:nil afterDelay:3.0];
        return;
    }
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getData)
                                                   object:nil];
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    delegate.curThread = myThread;
    [myThread start];
    self.status.text = @"正在下载数据，稍候哦......";
   
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


-(IBAction)goBtn:(id)sender
{
    [self performSegueWithIdentifier:@"gobtn" sender:sender];
}

-(void)gotoNext
{
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getData)
                                                   object:nil];
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    delegate.curThread = nil;
    
    [self performSegueWithIdentifier:@"gobtn" sender:self];
}

-(void)getData
{
    [SingleModel getSingleModal].delegate = self;
	[[SingleModel getSingleModal]refreshData:YES];
}

#pragma taobao data
-(void) finishedRefreshData
{
    NSLog(@"finishedRefreshData-end");
    [self performSelectorOnMainThread:@selector(gotoNext) withObject:nil waitUntilDone:NO];
}


@end
