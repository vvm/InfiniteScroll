//
//  ISView.m
//  InfiniteScroll
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 DremTop. All rights reserved.
//

#import "ISView.h"

@implementation ISView
@synthesize indentifier;
@synthesize indexPath;

-(id)initWithIndentifier:(NSString*)s
{
    [self init];
    indentifier = s;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        indentifier = nil;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andIndentifier:(NSString*)s
{
    [self initWithFrame:frame];
    indentifier = s;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
