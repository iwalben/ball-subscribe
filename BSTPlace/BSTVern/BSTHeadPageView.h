//
//  BSTHeadPageView.h
//  LHLC
//
//  Created by WalkerCloud on 2019/4/8.
//  Copyright © 2019年 Sameway. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSTHeadPageView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray <__kindof NSString *>*)items;

@property (nonatomic ,assign) NSInteger defaultIndex;

@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic ,copy) void(^currentIndexBlock)(NSInteger);

- (BOOL)selectIndex:(NSInteger)index;

@end




NS_ASSUME_NONNULL_END
