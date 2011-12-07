//
//  ISView.h
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISView : UIView
{
    NSString* indentifier;      // 标识
    NSIndexPath* indexPath;     // 所在
}
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,copy,readonly)NSString* indentifier;

-(id)initWithIndentifier:(NSString*)s;
-(id)initWithFrame:(CGRect)frame andIndentifier:(NSString*)s;
@end
