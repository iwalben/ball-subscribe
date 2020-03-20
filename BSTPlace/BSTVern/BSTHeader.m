//
//  BSTHeader.m
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

#import "BSTHeader.h"

@implementation BSTHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    BSTHeader *header =  [super headerWithRefreshingBlock:refreshingBlock];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.text = @"刷新中...";
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    header.automaticallyChangeAlpha = YES;
    return header;
}

@end
