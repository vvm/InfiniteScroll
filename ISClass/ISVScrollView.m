//
//  ISVScrollView.m
//  InfiniteScroll
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISVScrollView.h"

@implementation ISVScrollView

// 根据要选中的位置设置第一个元素及偏移
-(int) positionOfSelect:(CGFloat*) dis
{
    *dis = 0;
    if (tooShortContent)
        return 0;
    CGFloat centerY = viewHeight/2;
    CGFloat pickCenterY = pickRect.origin.y + pickRect.size.height/2;
    for (int i=0; i<numberOfSubViews; i++) {
        if (fabs(centerY - pickCenterY)<= viewHeight/2) {
            *dis = centerY-pickCenterY;
            int pos = selectIndex - i;
            selectIndex = i;
            return pos;
        }
        centerY += viewHeight;
    }
    return 0;
}

// 首次显示时在最前面多显示一个视图(视图与最后一个相同) shi终往下拉,所以嘴上面的边重叠或者最下面的边在区域内部
-(void) firstlayoutToShow
{
    [super firstlayoutToShow];
    // 调整滚动区域
    CGFloat lestHeight = self.frame.size.height + viewHeight*3;
    if (self.contentSize.height/self.frame.size.height <lestHeight) 
        self.contentSize = CGSizeMake(self.contentSize.width,lestHeight) ;
    // 内部视图太短,比如说只有1个内部视图之类
    if (numberOfSubViews*viewHeight < self.frame.size.height)
        tooShortContent = YES;
    // 把内容放在中间,这样就方便滚动不会超出范围了
    scrollDistance = (self.contentSize.height - self.frame.size.height )/2;
    if (tooShortContent)
        scrollDistance = (self.contentSize.height - (numberOfSubViews*viewHeight) )/2;
    
    
    CGFloat* dis = (CGFloat*)malloc(sizeof(CGFloat));
    int firstIndex = [self positionOfSelect:dis];
    self.contentOffset = CGPointMake(0, scrollDistance + *dis);
    free(dis);
    
    ISView* headView = [self viewForIndex:firstIndex-1];
    CGFloat scrollLimite = 0;
    CGFloat scrollUnit = 0;
    
    scrollLimite = tooShortContent?numberOfSubViews*viewHeight:self.frame.size.height + viewHeight;
    scrollUnit = viewHeight;
    headView.frame = CGRectMake(0, scrollDistance-viewHeight, viewWidth, viewHeight);

    if (!tooShortContent) {
        [self.viewArray addObject:headView];
        [self addSubview:headView];
        selectIndex++;
    }
    
    
    for (int i = firstIndex; (i-firstIndex)*scrollUnit< scrollLimite; i++) {
        ISView* view = [self viewForIndex:i];
        CGRect r = view.frame;
        r = CGRectMake(0, scrollDistance+(i-firstIndex)*scrollUnit, viewWidth, viewHeight);
        view.frame = r;
        [self.viewArray addObject:view];
        [self addSubview:view];
    }
    [self selectIndex:selectIndex];
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
    // 首次出现或者重载数据时,初始化subviews
    if (layoutFirst) {
        [self firstlayoutToShow];
        layoutFirst = !layoutFirst;
    }
    [super layoutSubviews];
    if (!tooShortContent) // 需要无限滚动,相应改变
        [self verticalScroll];
}

// 选择框相关
-(void)setPickRect:(CGRect)rect andDefaultIndex:(NSInteger)index
{
    [super setPickRect:rect andDefaultIndex:index];
    // rect为0时默认设置在中间
    if (CGRectEqualToRect(rect, CGRectZero))
        pickRect = CGRectMake(0, (self.frame.size.height-viewHeight )/2, viewWidth, viewHeight);
//    // 如果内容区域过小,重置滚动区域
//    if (tooShortContent) {
//        [self setContentSize:CGSizeMake(viewWidth, numberOfSubViews*viewHeight + self.frame.size.height)];
//    }
    [self setNeedsLayout];
}

-(BOOL) pointShouldFitRect:(CGPoint)p withRect:(CGRect)r
{
    CGFloat diffY = p.y - (r.origin.y + r.size.height/2);
    if (fabs(diffY) < viewHeight/2) 
        return YES;
    return NO;
}

-(void) visibleRect
{
    CGPoint currentOffset = [self contentOffset];
    CGPoint centerPoint = CGPointMake(0, 0);
    for (ISView* view in viewArray) {   // 找到合适的选择项
        CGRect r = view.frame;
        centerPoint = CGPointMake(viewWidth/2, r.origin.y -currentOffset.y + viewHeight/2);
        if ([self pointShouldFitRect:centerPoint withRect:pickRect]) {
            CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
            currentOffset.y += diffY;
            [self setContentOffset:currentOffset animated:YES];
            [self changeto:[viewArray indexOfObject:view]];
            return;
        }
    }
    // 下面是subviews不能充满整个frame情况下需要选择第一个或最后一个
    if (centerPoint.y > pickRect.origin.y) {
        [self selectIndex:0];
    }
    else
    {
        CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
        currentOffset.y += diffY;
        [self setContentOffset:currentOffset animated:YES];
        [self changeto:[viewArray count]-1];
    }
}

-(void)selectIndex:(NSInteger)index
{
    if (CGRectEqualToRect(pickRect, CGRectZero) || index >= numberOfSubViews || index < 0) {
        return;
    }
    if (tooShortContent) {
        CGPoint currentOffset = [self contentOffset];
        CGPoint centerPoint = CGPointMake(0, 0);
        ISView* view = [viewArray objectAtIndex:index];
        CGRect r = view.frame;
        centerPoint = CGPointMake(viewWidth/2, r.origin.y -currentOffset.y + viewHeight/2);
        CGFloat diffY = centerPoint.y - (pickRect.origin.y+pickRect.size.height/2);
        currentOffset.y += diffY;
        [self setContentOffset:currentOffset animated:YES];
    }
    [self changeto:index];
}
@end
