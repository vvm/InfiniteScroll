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
    // 内部视图太短,比如说只有1个内部视图之类
    if (numberOfSubViews*viewHeight < self.frame.size.height)
        tooShortContent = YES;
    // 把内容放在中间,这样就方便滚动不会超出范围了
    scrollDistance = (self.contentSize.height - self.frame.size.height )/2;
    if (tooShortContent)
        scrollDistance = (self.contentSize.height - (numberOfSubViews*viewHeight) )/2;
    self.contentOffset = CGPointMake(0, scrollDistance);
    
    
    ISView* headView = [self viewForIndex:numberOfSubViews-1];
    CGFloat scrollLimite = 0;
    CGFloat scrollUnit = 0;
    
    scrollLimite = tooShortContent?numberOfSubViews*viewHeight:self.frame.size.height + viewHeight;
    scrollUnit = viewHeight;
    headView.frame = CGRectMake(0, scrollDistance-viewHeight, viewWidth, viewHeight);

    if (!tooShortContent) {
        [self.viewArray addObject:headView];
        [self addSubview:headView];
    }
    
    
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
    static BOOL firstTime = YES;
    if (firstTime) {
        [self firstlayoutToShow];
        firstTime = !firstTime;
    }
    [super layoutSubviews];
    if (!tooShortContent) 
        [self verticalScroll];
}

// 选择框相关
-(void)setPickRect:(CGRect)rect
{
    // rect为0时默认设置在中间
    if (CGRectEqualToRect(rect, CGRectZero))
        pickRect = CGRectMake(0, (self.frame.size.height-viewHeight )/2, viewWidth, viewHeight);
    else
        [super setPickRect:rect];
    // 如果内容区域过小,重置滚动区域
    if (tooShortContent) {
        [self setContentSize:CGSizeMake(viewWidth, numberOfSubViews*viewHeight + self.frame.size.height)];
    }
}

-(void) visibleRect
{
    CGPoint currentOffset = [self contentOffset];
    CGPoint centerPoint = CGPointMake(0, 0);
    for (ISView* view in viewArray) {
        CGRect r = view.frame;
        centerPoint = CGPointMake(viewWidth/2, r.origin.y -currentOffset.y + viewHeight/2);
        if (CGRectContainsPoint(pickRect, centerPoint)) {
            CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
            currentOffset.y += diffY;
            [self setContentOffset:currentOffset animated:YES];
            return;
        }
    }
    if (centerPoint.y > pickRect.origin.y) {
        ISView* view = [viewArray objectAtIndex:0];
        CGRect r = view.frame;
        centerPoint = CGPointMake(viewWidth/2, r.origin.y -currentOffset.y + viewHeight/2);
        CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
        currentOffset.y += diffY;
        [self setContentOffset:currentOffset animated:YES];
    }
    else
    {
        CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
        currentOffset.y += diffY;
        [self setContentOffset:currentOffset animated:YES];
    }
    
    
}
@end
