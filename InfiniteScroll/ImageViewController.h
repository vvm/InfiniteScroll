//
//  ImageViewController.h
//  InfiniteScroll
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHScrollView.h"

@interface ImageViewController : UIViewController<ISScrollViewDelegate>
{
    IBOutlet ISHScrollView* imageScroll;
}
@end
