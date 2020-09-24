//
//  UIView+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LC)

@property CGPoint origin;
@property CGSize size;

@property CGFloat x;
@property CGFloat y;
@property CGFloat width;
@property CGFloat height;
@property CGFloat centerX;
@property CGFloat centerY;

@property (readonly) CGFloat left;
@property (readonly) CGFloat top;
@property (readonly) CGFloat right;
@property (readonly) CGFloat bottom;

@end

NS_ASSUME_NONNULL_END
