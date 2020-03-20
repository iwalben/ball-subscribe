//
//  PNCChoosePhotoCell.m
//  CBNT
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 Sameway. All rights reserved.
//

#import "PNCChoosePhotoCell.h"

@interface PNCChoosePhotoCell()

@end

@implementation PNCChoosePhotoCell

- (void)setCurrentImage:(UIImage *)currentImage{
    _currentImage = currentImage;
    if (_currentImage) {
        self.backgroundImageView.image = currentImage;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.deleteBtn.hidden = NO;
    }else{
        self.backgroundImageView.image = [UIImage imageNamed:@"pnc_help_add"];
        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        self.deleteBtn.hidden = YES;
    }
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_backgroundImageView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"pnc_help_delete"] forState:0];
        
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        _backgroundImageView.frame =  self.bounds;
        deleteBtn.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);
    }
    return _backgroundImageView;
}

- (void)deleteClick
{
    !self.deleteBlock?:self.deleteBlock();
}

@end
