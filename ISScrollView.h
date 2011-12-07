//
//  ISScrollView.h
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISView.h"

@protocol ISScrollViewDelegate
-(NSInteger) numberOfSubViews;          // 子视图个数
-(ISView*) viewForIndex:(NSInteger)index;                // 申请子视图

@end


@interface ISScrollView : UIScrollView
{
    CGFloat scrollDistance;
    NSInteger numberOfSubViews;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSMutableDictionary* viewDictionary;    // 重用视图记录表
    NSMutableArray* viewArray;              // 当前所有子view顺序
    id<ISScrollViewDelegate,UIScrollViewDelegate> delegate;
    
}
@property(nonatomic,retain) NSMutableDictionary* viewDictionary;
@property(nonatomic,retain) NSMutableArray* viewArray;
@property(nonatomic,assign) id<ISScrollViewDelegate,UIScrollViewDelegate> delegate;

-(id)initWithWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height;

-(ISView*) dequeueReusableCellWithIdentifier:(NSString*)identifier;


-(ISView*) viewForIndex:(NSInteger)index;
-(void) firstlayoutToShow;
@end


