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
    NSIndexPath *oldPath;                   // 签一次选择的项
    BOOL layoutFirst;                       // 第一次加载
    SType sType;
    BOOL tooShortContent;                   // content不能充满整个frame
    CGFloat scrollDistance;                 // 初始偏移,方便两个方向滚动
    NSInteger numberOfSubViews;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    NSMutableDictionary* viewDictionary;    // 重用视图记录表
    NSMutableArray* viewArray;              // 当前所有子view顺序
    id<ISScrollViewDelegate,NSObject> isdelegate;
    
    CGRect pickRect;                        // 选择框
    NSInteger selectIndex;                  // 选择的索引,所选view在viewArray中的位置
}
@property(nonatomic,retain) NSMutableDictionary* viewDictionary;
@property(nonatomic,retain) NSMutableArray* viewArray;
@property(nonatomic,assign) id<ISScrollViewDelegate,NSObject> isdelegate;
@property(nonatomic,retain) NSIndexPath *oldPath;

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
-(void) changeto:(NSInteger)t;

-(ISView*)currentSelect;    // 当前选中视图
@end


@protocol ISScrollViewDelegate
-(NSInteger) numberOfSubViews:(ISScrollView*)s;          // 子视图个数
-(ISView*) viewForScroll:(ISScrollView*)s AtIndex:(NSInteger)index;                // 申请子视图
@optional
-(void) scrollView:(ISScrollView*)s ChangeSelectedFrom:(NSIndexPath*)oldSel to:(NSIndexPath*)sel;// 选项改变
@end