//
//  ImageViewController.m
//  InfiniteScroll
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

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
    imageScroll.isdelegate = self;
    [imageScroll setContentSize:CGSizeMake(320*3, 416)];
    [imageScroll setWidth:320 andHeight:416];
    [imageScroll setPickRect:CGRectMake(0, 0, 320, 416) andDefaultIndex:1];
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

-(ISView *)viewForScroll:(ISScrollView *)s AtIndex:(NSInteger)index
{
    static NSString* identifier = @"image";
    ISView* view = [s dequeueReusableCellWithIdentifier:identifier];
    UILabel* label = nil;
    if (view == nil) {
        view = [[ISView alloc] initWithFrame:s.bounds andIndentifier:identifier];
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
        label.tag = 110;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:20];
        [view addSubview:label];
    }
    if (label == nil) {
        label = (UILabel*)[view viewWithTag:110];
    }
    CGRect r = label.frame;
    r.origin.y = index*20;
    label.frame = r;
    label.text = [NSString stringWithFormat:@"image:%d",index];

    return view;
}

-(NSInteger)numberOfSubViews:(ISScrollView *)s
{
    return 6;
}
@end
