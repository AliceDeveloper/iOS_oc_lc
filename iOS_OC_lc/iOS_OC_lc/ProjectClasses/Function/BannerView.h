//
//  BannerView.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/22.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - BannerDelegate

@protocol BannerDelegate <NSObject>

// 类似于 tableview 的重载机制
- (NSUInteger)bannerItemCount;
- (void)bannerItem:(BannerItem *)bannerItem index:(NSUInteger)index;
- (void)bannerItemClicked:(NSUInteger)index;

@end

#pragma mark -
#pragma mark - BannerItem

@interface BannerItem : UIView

@property (nonatomic, strong) UIImageView *imageView;

@end

#pragma mark -
#pragma mark - Banner

@interface BannerView : UIView

@property (nonatomic, weak) id <BannerDelegate> delegate;

// 用该方法初始化Banner视图
- (instancetype)initWithFrame:(CGRect)frame;
// 加载数据或者刷新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
