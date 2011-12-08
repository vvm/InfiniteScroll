//
//  DatePickerController.m
//  InfiniteScroll
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "DatePickerController.h"

@implementation DatePickerController

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
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    [calendar setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"CN"] autorelease]];
    dateComponents = [[calendar components:(NSYearCalendarUnit|NSDayCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]] retain];

    
    yearScroll.isdelegate = self;
    [yearScroll setWidth:150 andHeight:50];
    [yearScroll setContentSize:CGSizeMake(150, 450)];
    [yearScroll setPickRect:CGRectZero andDefaultIndex:dateComponents.year];
    moonScroll.isdelegate = self;
    [moonScroll setWidth:80 andHeight:50];
    [moonScroll setContentSize:CGSizeMake(80, 450)];
    [moonScroll setPickRect:CGRectZero andDefaultIndex:dateComponents.month];
    dayScroll.isdelegate = self;
    [dayScroll setWidth:80 andHeight:50];
    [dayScroll setContentSize:CGSizeMake(80, 450)];
    [dayScroll setPickRect:CGRectZero andDefaultIndex:dateComponents.day];
    
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

-(NSInteger)numberOfSubViews:(ISScrollView *)s
{
    NSRange r = NSMakeRange(0, 0);
    if (s.tag == 1) {
        r = [calendar maximumRangeOfUnit:NSYearCalendarUnit];
    }
    else if (s.tag == 2)
    {
        NSDate* date = [calendar dateFromComponents:dateComponents];
        r = [calendar rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
    }
    else
    {
        NSDate* date = [calendar dateFromComponents:dateComponents];
        r = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    }
    return r.length;
}

-(ISView *)viewForScroll:(ISScrollView *)s AtIndex:(NSInteger)index
{
    
    static NSString* identifier = @"calendar";
    ISView* view = [s dequeueReusableCellWithIdentifier:identifier];
    UILabel* label = nil;
    if (view == nil) {
        view = [[ISView alloc] initWithFrame:s.bounds andIndentifier:identifier];
        view.backgroundColor = [UIColor blueColor];
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)] autorelease];
        label.tag = 120;
        [view addSubview:label];
    }
    if (label == nil)
        label = (UILabel*)[view viewWithTag:120];
    if (s.tag == 1) {
        label.text = [NSString stringWithFormat:@"%d",index+1];
    }
    else if (s.tag == 2) {
        label.text = [NSString stringWithFormat:@"%d月",index+1];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%d",index+1];
    }
    return view;
}

-(void) scrollView:(ISScrollView*)s ChangeSelectedFrom:(NSIndexPath*)oldSel to:(NSIndexPath*)sel
{
    if (s.tag == 1) {
        [dateComponents setYear:sel.row];
        [moonScroll reloadData];
        [dayScroll reloadData];
    }
    else if (s.tag == 2)
    {
        [dateComponents setMonth:sel.row];
        [dayScroll reloadData];
    }
    else if (s.tag == 3)
    {
        [dateComponents setDay:sel.row];
        NSLog(@"day se:%d",sel.row);
    }
}

@end
