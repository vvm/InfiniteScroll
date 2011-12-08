//
//  ISScrollView.h
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISView.h"


typedef enum
{
    vScroll = 0,
    hScroll,
    aScroll
}SType;

@protocol ISScrollViewDelegate;

@interface ISScrollView : UIScrollView<UIScrollViewDelegate>
{
    BOOL layoutFirst;
    SType sType;
    BOOL tooShortContent;
    CGFloat scrollDistance;                 // 初始偏移,方便两个方向滚动
    NSInteger numberOfSubViews;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSMutableDictionary* viewDictionary;    // 重用视图记录表
    NSMutableArray* viewArray;              // 当前所有子view顺序
    id<ISScrollViewDelegate> isdelegate;
    
    CGRect pickRect;                        // 选择框
    NSInteger selectIndex;                  // 选择的索引
}
@property(nonatomic,retain) NSMutableDictionary* viewDictionary;
@property(nonatomic,retain) NSMutableArray* viewArray;
@property(nonatomic,assign) id<ISScrollViewDelegate> isdelegate;

-(id)initWithWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)setPickRect:(CGRect)rect andDefaultIndex:(NSInteger)index;

-(ISView*) dequeueReusableCellWithIdentifier:(NSString*)identifier; // 从重用中查找
-(ISView*) viewForIndex:(NSInteger)index;   // 从代理中得到

-(void) firstlayoutToShow;              // 开始显示时的设置
-(void) visibleRect;

-(void) selectIndex:(NSInteger)index;
-(BOOL) pointShouldFitRect:(CGPoint)p withRect:(CGRect)r;

-(void) reloadData;
@end


@protocol ISScrollViewDelegate
-(NSInteger) numberOfSubViews:(ISScrollView*)s;          // 子视图个数
-(ISView*) viewForScroll:(ISScrollView*)s AtIndex:(NSInteger)index;                // 申请子视图
@end