//
//  ISScrollView.m
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISScrollView.h"

@implementation ISScrollView
@synthesize viewArray;
@synthesize viewDictionary;
@synthesize isdelegate;


// nib 加载
-(void)awakeFromNib
{
    self.viewArray = [[NSMutableArray alloc] init];
    self.viewDictionary = [[NSMutableDictionary alloc] init];
}

// 初始化
-(id)init
{
    self = [super init];
    if (self) {
        self.viewArray = [[NSMutableArray alloc] init];
        self.viewDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// 滚动单位的宽和高
-(id)initWithWidth:(CGFloat)width andHeight:(CGFloat)height
{
    [self init];
    [self setWidth:width andHeight:height];
    return self;
}
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height
{
    viewWidth = width;
    viewHeight = height;
}

// 添加内部视图,方便重用
-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if ([view isKindOfClass:[ISView class]]) {
        NSString* s = ((ISView*)view).indentifier;
        if (s != nil) {
            NSMutableArray* array = [viewDictionary objectForKey:s];
            if (array == nil) {
                array = [NSMutableArray arrayWithCapacity:1];
                [viewDictionary setObject:array forKey:s];
            }
        }
        
    }
}

// 主要是为了记录index
-(ISView*) viewForIndex:(NSInteger)index
{
    if (numberOfSubViews < 1) {
        return nil;
    }
    // 实际的索引位置
    NSInteger realIndex = index % numberOfSubViews;
    ISView* view = [[isdelegate viewForScroll:self AtIndex:realIndex] autorelease];
    view.indexPath = [NSIndexPath indexPathForRow:realIndex inSection:0];
    return view;
}

// 首次显示时在最前面多显示一个视图(视图与最后一个相同)
-(void) firstlayoutToShow
{        
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    numberOfSubViews = [isdelegate numberOfSubViews:self];
    tooShortContent = NO;
}

// 根据标识查找可重用的视图
-(ISView*) dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    NSMutableArray* array = [viewDictionary objectForKey:identifier];
    if (array == nil || [array count]==0) {
        return nil;
    }
    
    ISView* view = [[array lastObject] retain];
    [array removeLastObject];
    return view;
}

// 滚动就相应调整
-(void)layoutSubviews
{
    [super layoutSubviews];
}


-(void)dealloc
{
    [viewDictionary release];
    [viewArray release];
    [super dealloc];
}

// 下面系列是对有选择框时进行选择
#pragma scroll view delegate
// 使用自己作代理
-(void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    if ([delegate isEqual:self]) {
        [super setDelegate:delegate];
    }
    return;
}

-(void)setPickRect:(CGRect)rect
{
    CGRect r = CGRectUnion(self.bounds, rect);
    pickRect = r;
}

-(void)visibleRect{};

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && !CGRectEqualToRect(pickRect, CGRectZero)) {
        [self visibleRect];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!CGRectEqualToRect(pickRect, CGRectZero)) {
        [self visibleRect];
    }
    
}

// 高级功能
-(void) selectIndex:(NSInteger)index
{
    
}

@end
