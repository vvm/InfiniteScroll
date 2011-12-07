//
//  ISVScrollView.m
//  InfiniteScroll
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISVScrollView.h"

@implementation ISVScrollView

// 首次显示时在最前面多显示一个视图(视图与最后一个相同)
-(void) firstlayoutToShow
{
    [super firstlayoutToShow];
    // 把内容放在中间,这样就方便滚动不会超出范围了
    scrollDistance = (self.contentSize.height - self.frame.size.height )/2;
    self.contentOffset = CGPointMake(0, scrollDistance);
    
    ISView* headView = [self viewForIndex:numberOfSubViews-1];
    CGFloat scrollLimite = 0;
    CGFloat scrollUnit = 0;
    
    scrollLimite = self.frame.size.height + viewHeight;
    scrollUnit = viewHeight;
    headView.frame = CGRectMake(0, scrollDistance-viewHeight, viewWidth, viewHeight);

    [self.viewArray addObject:headView];
    [self addSubview:headView];
    
    for (int i = 0; i< scrollLimite; i+=scrollUnit) {
        ISView* view = [self viewForIndex:i/scrollUnit];
        CGRect r = view.frame;
        r = CGRectMake(0, scrollDistance+i, viewWidth, viewHeight);
        view.frame = r;
        [self.viewArray addObject:view];
        [self addSubview:view];
    }
}

// 纵向滚动
-(void)verticalScroll
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat distanceY = 0;
    if ((currentOffset.y-scrollDistance) > viewHeight || (currentOffset.y-scrollDistance) < -viewHeight) {
        if (currentOffset.y-scrollDistance > viewHeight) {
            distanceY = currentOffset.y - viewHeight;
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
        else if (currentOffset.y-scrollDistance < -viewHeight) {
            distanceY = viewHeight + currentOffset.y;
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
        CGFloat h = -viewHeight;
        for (ISView* view in viewArray) {
            view.frame = CGRectMake(0, scrollDistance+h, viewWidth,viewHeight);
            h += viewHeight;
        }
        [self setContentOffset:CGPointMake(0,  distanceY)];
    }
    
    
}

// 滚动就相应调整
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self verticalScroll];
}
@end
