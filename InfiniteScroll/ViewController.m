//
//  ViewController.m
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [myScrollView setWidth:60 andHeight:60];
    myScrollView.isdelegate = self;
    [myScrollView setContentSize:CGSizeMake(60, 500)];
    [myScrollView setPickRect:CGRectZero andDefaultIndex:0];
    
    
    
    [myHScrollView setWidth:60 andHeight:60];
    myHScrollView.isdelegate = self;
    [myHScrollView setContentSize:CGSizeMake(500, 60)];
    [myHScrollView setPickRect:CGRectZero andDefaultIndex:22];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(ISView *)viewForScroll:(ISScrollView *)s AtIndex:(NSInteger)index
{//60*300
    static NSString* indentifier = @"cell";
    ISView* view = [myScrollView dequeueReusableCellWithIdentifier:indentifier];
    UILabel* label = nil;
    if (view == nil) {
        view = [[ISView alloc] initWithFrame:CGRectMake(0, 0, 60, 60) andIndentifier:indentifier];
        view.backgroundColor = [UIColor blueColor];
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
        label.tag = 119;
        [view addSubview:label];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 60, 1)];
        lineView.backgroundColor = [UIColor greenColor];
        [view addSubview:lineView];
    }
    if (label == nil) 
        label = (UILabel*)[view viewWithTag:119];
    label.text = [NSString stringWithFormat:@"%d",index];
    return view;
}


-(NSInteger)numberOfSubViews:(ISScrollView *)s
{
    if (s.tag == 11)
        return 13;
    if (s.tag == 22)
        return 33;
    return 0;
}

@end
