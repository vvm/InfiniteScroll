//
//  ISHScrollView.m
//  InfiniteScroll
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISHScrollView.h"

@implementation ISHScrollView

// 根据要选中的位置设置第一个元素及偏移
-(int) positionOfSelect:(CGFloat*) dis
{
    *dis = 0;
    if (tooShortContent)
        return 0;
    CGFloat centerX = viewWidth/2;
    CGFloat pickCenterX = pickRect.origin.x + pickRect.size.width/2;
    for (int i=0; i<numberOfSubViews; i++) {
        if (fabs(centerX - pickCenterX)<= viewWidth/2) {
            *dis = centerX-pickCenterX;
            int pos = selectIndex - i;
            selectIndex = i;
            return pos;
        }
        centerX += viewWidth;
    }
    return 0;
}

// 首次显示时在最前面多显示一个视图(视图与最后一个相同)  
-(void) firstlayoutToShow
{    
    [super firstlayoutToShow];
    if (self.contentSize.width/self.frame.size.width <3) {
        self.contentSize = CGSizeMake(self.frame.size.width*3, self.contentSize.height) ;
    }
    // 把内容放在中间,这样就方便滚动不会超出范围了
    if (numberOfSubViews*viewWidth < self.frame.size.width)
        tooShortContent = YES;
    scrollDistance = (self.contentSize.width - self.frame.size.width )/2;
    if (tooShortContent)
        scrollDistance = (self.contentSize.width - (numberOfSubViews*viewWidth) )/2;
    
    CGFloat* dis = (CGFloat*)malloc(sizeof(CGFloat));
    int firstIndex = [self positionOfSelect:dis];
    self.contentOffset = CGPointMake(scrollDistance + *dis, 0);
    free(dis);
    
    ISView* headView = [self viewForIndex:firstIndex-1];
    CGFloat scrollLimite = 0;
    CGFloat scrollUnit = 0;

    scrollLimite = tooShortContent?numberOfSubViews*viewWidth:self.frame.size.width + viewWidth;
    scrollUnit = viewWidth;
    headView.frame = CGRectMake(-viewWidth,0 , viewWidth, viewHeight);

    if (!tooShortContent) {
        [self.viewArray addObject:headView];
        [self addSubview:headView];
    }
    
    for (int i = firstIndex; (i-firstIndex)*scrollUnit< scrollLimite; i++) {
        ISView* view = [self viewForIndex:i];
        CGRect r = view.frame;
        r = CGRectMake(scrollDistance+(i-firstIndex)*scrollUnit, 0, viewWidth, viewHeight);
        view.frame = r;
        [self.viewArray addObject:view];
        [self addSubview:view];
    }
    [self selectIndex:selectIndex];
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
    if (layoutFirst) {
        [self firstlayoutToShow];
        layoutFirst = !layoutFirst;
    }
    [super layoutSubviews];
    if (!tooShortContent)
        [self horizontalScroll];
}

// 选择框相关
-(void)setPickRect:(CGRect)rect andDefaultIndex:(NSInteger)index
{
    [super setPickRect:rect andDefaultIndex:index];
    // 默认在中间
    if (CGRectEqualToRect(rect, CGRectZero))
        pickRect = CGRectMake((self.frame.size.width-viewWidth )/2, 0, viewWidth, viewHeight);
//    // 如果内容区域过小,重置滚动区域
//    if (tooShortContent) {
//        [self setContentSize:CGSizeMake(numberOfSubViews*viewWidth + self.frame.size.width,viewHeight)];
//    }
    [self setNeedsLayout];
}

-(BOOL) pointShouldFitRect:(CGPoint)p withRect:(CGRect)r
{
    CGFloat diffX = p.x - (r.origin.x + r.size.width/2);
    if (fabs(diffX) < viewWidth/2) 
        return YES;
    return NO;
}

-(void) visibleRect
{
    CGPoint currentOffset = [self contentOffset];
    CGPoint centerPoint = CGPointMake(0, 0);
    for (ISView* view in viewArray) {
        CGRect r = view.frame;
        centerPoint = CGPointMake(r.origin.x -currentOffset.x + viewWidth/2,viewHeight/2 );
        if ([self pointShouldFitRect:centerPoint withRect:pickRect]) {
            CGFloat diffX = centerPoint.x - (pickRect.origin.x+pickRect.size.width/2);
            currentOffset.x += diffX;
            [self setContentOffset:currentOffset animated:YES];
            [self changeto:[viewArray indexOfObject:view]];
            return;
        }
    }
    if (centerPoint.x > pickRect.origin.x) {
        [self selectIndex:0];
    }
    else
    {
        CGFloat diffX = centerPoint.x - (pickRect.origin.x+pickRect.size.width/2);
        currentOffset.x += diffX;
        [self setContentOffset:currentOffset animated:YES];
        [self changeto:[viewArray count]-1];
    }
}

-(void)selectIndex:(NSInteger)index
{
    if (CGRectEqualToRect(pickRect, CGRectZero) || index >= numberOfSubViews) {
        return;
    }
    if (tooShortContent) {
        CGPoint currentOffset = [self contentOffset];
        CGPoint centerPoint = CGPointMake(0, 0);
        ISView* view = [viewArray objectAtIndex:index];
        CGRect r = view.frame;
        centerPoint = CGPointMake(r.origin.x -currentOffset.x + viewWidth/2,viewHeight/2);
        CGFloat diffX = centerPoint.x - (pickRect.origin.x+pickRect.size.width/2);
        currentOffset.x += diffX;
        [self setContentOffset:currentOffset animated:YES];
    }
    [self changeto:index];
}
@end