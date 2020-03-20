//
//  PNCChoosePhotoCell.h
//  CBNT
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 Sameway. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNCChoosePhotoCell : UICollectionViewCell

@property (nonatomic ,strong , nullable) UIImage *currentImage;
@property (nonatomic ,strong) UIImageView *backgroundImageView;
@property (nonatomic ,copy) void(^deleteBlock)(void);
@property (nonatomic ,strong) UIButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
