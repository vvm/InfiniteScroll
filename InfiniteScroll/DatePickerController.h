//
//  DatePickerController.h
//  InfiniteScroll
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISVScrollView.h"

@interface DatePickerController : UIViewController<ISScrollViewDelegate>
{
    IBOutlet ISVScrollView* yearScroll;
    IBOutlet ISVScrollView* moonScroll;
    IBOutlet ISVScrollView* dayScroll;
    IBOutlet UILabel* pickLabel;
    
    NSCalendar* calendar;
    NSDateComponents *dateComponents;
}

@end
