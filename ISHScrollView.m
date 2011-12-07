//
//  ISHScrollView.m
//  InfiniteScroll
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISHScrollView.h"

@implementation ISHScrollView
// 首次显示时在最前面多显示一个视图(视图与最后一个相同)
-(void) firstlayoutToShow
{
    [super firstlayoutToShow];
    // 把内容放在中间,这样就方便滚动不会超出范围了
    scrollDistance = (self.contentSize.width - self.frame.size.width )/2;
    self.contentOffset = CGPointMake(scrollDistance, 0);
    
    ISView* headView = [self viewForIndex:numberOfSubViews-1];
    CGFloat scrollLimite = 0;
    CGFloat scrollUnit = 0;

    scrollLimite = self.frame.size.width + viewWidth;
    scrollUnit = viewWidth;
    headView.frame = CGRectMake(-viewWidth,0 , viewWidth, viewHeight);

    [self.viewArray addObject:headView];
    [self addSubview:headView];
    
    for (int i = 0; i< scrollLimite; i+=scrollUnit) {
        ISView* view = [self viewForIndex:i/scrollUnit];
        CGRect r = view.frame;
        r = CGRectMake(i, 0, viewWidth, viewHeight);
        view.frame = r;
        [self.viewArray addObject:view];
        [self addSubview:view];
    }
}

-(void) horizontalScroll
{
    CGPoint currentOffset = [self contentOffset];
    if (currentOffset.y > 50) {
        CGFloat distanceY = currentOffset.y - 50;
        ISView* oldView = [self.viewArray objectAtIndex:0];
        [oldView removeFromSuperview];
        [self.viewArray removeObjectAtIndex:0];
        ISView* firstView = [viewArray objectAtIndex:0];
        ISView* newView = [[ISView alloc] initWithFrame:CGRectMake(0, 360, 70, 50)];
        newView.backgroundColor = firstView.backgroundColor;
        [self addSubview:newView];
        [self.viewArray addObject:newView];
        
        CGFloat h = -100;
        for (ISView* view in viewArray) {
            h += 50;
            view.frame = CGRectMake(0, h, 70,50);
        }
        [self setContentOffset:CGPointMake(0, distanceY)];
    }
    else if (currentOffset.y < 0) {
        CGFloat distanceY = 50 - currentOffset.y;
        ISView* oldView = [self.viewArray lastObject];
        [oldView removeFromSuperview];
        [self.viewArray removeObjectAtIndex:[viewArray count]-1];
        ISView* lastView = [viewArray lastObject];
        ISView* newView = [[ISView alloc] initWithFrame:CGRectMake(0, -50, 70, 50)];
        newView.backgroundColor = lastView.backgroundColor;
        [self addSubview:newView];
        [self.viewArray insertObject:newView atIndex:0];
        
        CGFloat h = -100;
        for (ISView* view in viewArray) {
            h += 50;
            view.frame = CGRectMake(0, h, 70,50);
        }
        [self setContentOffset:CGPointMake(0, distanceY)];
    }
}

// 滚动就相应调整
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self horizontalScroll];
}
@end
