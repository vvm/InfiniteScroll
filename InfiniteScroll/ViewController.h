//
//  ViewController.h
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISVScrollView.h"
#import "ISHScrollView.h"

@interface ViewController : UIViewController<ISScrollViewDelegate,UIScrollViewDelegate>
{
    IBOutlet ISVScrollView* myScrollView;
    IBOutlet ISHScrollView* myHScrollView;
}
@end
