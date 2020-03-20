//
//  BSTHeadPageView.m
//  LHLC
//
//  Created by WalkerCloud on 2019/4/8.
//  Copyright © 2019年 Sameway. All rights reserved.
//

#import "BSTHeadPageView.h"
#import <JKCategories/JKFoundation.h>
#import <JKCategories/UIColor+JKHEX.h>
#import <JKCategories/UIColor+JKGradient.h>
#import <JKCategories/UIFont+JKTTF.h>
#import <JKCategories/UIView+JKFrame.h>
#import <JKCategories/UIView+JKBlockGesture.h>
#import <JKCategories/UIAlertView+JKBlock.h>
#import <JKCategories/UIButton+JKBlock.h>
#import <JKCategories/UIImage+JKColor.h>
#import <JKCategories/UITextField+JKBlocks.h>
#import <JKCategories/UIImage+JKSuperCompress.h>

#define BSTPPOColor [UIColor jk_colorWithHex:0x95C060]

@interface BSTHeadPageView ()
@property(nonatomic,strong)UIImageView *indicator;
@property(nonatomic,strong)UIScrollView *headerScrollView;
@property(nonatomic,strong)UIButton *currentButton;
@property(nonatomic,strong)NSArray *items;
@end

@implementation BSTHeadPageView

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray <__kindof NSString *>*)items{
    
    if (self = [super initWithFrame:frame]) {
        
        _currentIndex = 0;
        _defaultIndex = 0;
        _items = items;
        //当item的count 大于四个时，使用可滑动item
        self.headerScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            scrollView.frame = self.bounds;
            scrollView.backgroundColor = UIColor.whiteColor;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.layer.shadowColor = [UIColor lightGrayColor].CGColor; //shadowColor阴影颜色
            scrollView.layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
            scrollView.layer.shadowOpacity = 0.2f;//阴影透明度，默认0
            scrollView.layer.shadowRadius = 2.0f;
            scrollView;
        });
        
        [self addSubview:self.headerScrollView];
        
        CGFloat w;
        if (items.count > 5) {
            w = (frame.size.width - 50) / 4;
        }else{
            w = frame.size.width/items.count;
        }
        CGFloat h = frame.size.height;
        for (int i = 0; i < items.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitle:items[i] forState:0];
            [button setTitleColor:UIColor.lightGrayColor forState:0];
            [button setTitleColor:BSTPPOColor forState:UIControlStateSelected];
            [button sizeToFit];
            button.tag = i + 100;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(i * w, 0, w, h);
            [self.headerScrollView addSubview:button];
        }
        
        _headerScrollView.contentSize = CGSizeMake(w * items.count, h);
        
        _indicator = [UIImageView new];
        _indicator.image = [UIImage jk_imageWithColor:BSTPPOColor];
        _indicator.jk_width = 30;
        _indicator.jk_height = 2;
        _indicator.jk_top = self.headerScrollView.jk_height - _indicator.jk_height;
        _indicator.jk_right = 0;
        [self.headerScrollView addSubview:_indicator];
    }
    return self ;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        id sender = [self.headerScrollView viewWithTag:100 + self.defaultIndex];
        if ([sender isKindOfClass:[UIButton class]]) {
            [self buttonAction:sender];
        }else{
            [self buttonAction:[self.headerScrollView viewWithTag:100]];
        }
    }
}

- (BOOL)selectIndex:(NSInteger)index{
    UIButton *button = [_headerScrollView viewWithTag:index + 100];
    if (!button) {
        return NO;
    }
    [self buttonAction:button];
    return YES;
}

- (void)buttonAction:(UIButton *)sender{
    if (sender == self.currentButton) {
        return;
    }
    sender.selected = YES;
    self.currentButton.selected = NO;
    self.currentButton = sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.jk_centerX = sender.jk_centerX;
    }];
    
    CGFloat offsetX = sender.jk_centerX - self.jk_width * 0.5;
    CGFloat maxOffsetX = self.headerScrollView.contentSize.width - self.jk_width;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.headerScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    if (self.currentIndexBlock) {
        self.currentIndexBlock(sender.tag);
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end



