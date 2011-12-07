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
@synthesize delegate;

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

-(ISView*) viewForIndex:(NSInteger)index
{
    // 实际的索引位置
    NSInteger realIndex = index % numberOfSubViews;
    ISView* view = [[delegate viewForIndex:realIndex] autorelease];
    view.indexPath = [NSIndexPath indexPathForRow:realIndex inSection:0];
    return view;
}

// 首次显示时在最前面多显示一个视图(视图与最后一个相同)
-(void) firstlayoutToShow
{        
    numberOfSubViews = [delegate numberOfSubViews];
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
    static BOOL firstTime = YES;
    if (firstTime) {
        [self firstlayoutToShow];
        firstTime = !firstTime;
    }
    
    [super layoutSubviews];
}

-(void)dealloc
{
    [super dealloc];
}

@end
