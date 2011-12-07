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
    CGFloat distanceX = 0;
    if ((currentOffset.x-scrollDistance) > viewWidth || (currentOffset.x-scrollDistance) < -viewWidth) {
        if (currentOffset.x-scrollDistance > viewWidth) {
            distanceX = currentOffset.x - viewHeight;
            ISView* oldView = [self.viewArray objectAtIndex:0];
            NSMutableArray * array = [viewDictionary objectForKey:oldView.indentifier];
            if (array != nil)
                [array addObject:oldView];
            [oldView removeFromSuperview];
            [self.viewArray removeObjectAtIndex:0];
            int lastIndex = [[(ISView*)[viewArray lastObject] indexPath] row];
            ISView* newView = [self viewForIndex:lastIndex+1];
            [self addSubview:newView];
            [self.viewArray addObject:newView];
        }
        else if (currentOffset.x-scrollDistance < -viewWidth) {
            distanceX = viewHeight + currentOffset.x;
            ISView* oldView = [self.viewArray lastObject];
            NSMutableArray * array = [viewDictionary objectForKey:oldView.indentifier];
            if (array != nil)
                [array addObject:oldView];
            [oldView removeFromSuperview];
            [self.viewArray removeObjectAtIndex:[viewArray count]-1];
            int headIndex = [[(ISView*)[viewArray objectAtIndex:0] indexPath] row];
            ISView* newView = [self viewForIndex:headIndex-1+numberOfSubViews];
            [self addSubview:newView];
            [self.viewArray insertObject:newView atIndex:0];
        }
        CGFloat h = -viewWidth;
        for (ISView* view in viewArray) {
            view.frame = CGRectMake(scrollDistance+h, 0, viewWidth,viewHeight);
            h += viewWidth;
        }
        [self setContentOffset:CGPointMake(distanceX, 0)];
    }
}

// 滚动就相应调整
-(void)layoutSubviews
{
    static BOOL firstTime = YES;
    if (firstTime) {
        [self firstlayoutToShow];
        firstTime = !firstTime;
    }
    [super layoutSubviews];
    [self horizontalScroll];
}
@end
