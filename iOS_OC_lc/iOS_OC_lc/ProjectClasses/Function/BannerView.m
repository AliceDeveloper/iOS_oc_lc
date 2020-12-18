//
//  BannerView.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/22.
//  Copyright © 2020 lc. All rights reserved.
//

#import "BannerView.h"

#pragma mark -
#pragma mark - BannerItem

@implementation BannerItem

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds = YES;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end

#pragma mark -
#pragma mark - Banner

@interface BannerView () <UIScrollViewDelegate>

// 视图控件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) BannerItem *left;
@property (nonatomic, strong) BannerItem *middle;
@property (nonatomic, strong) BannerItem *right;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger middleIndex;
@property (nonatomic, assign) NSInteger rightIndex;
// 数据源
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BannerView

// 用该方法创建视图
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(width * 3, height);
        self.scrollView.contentOffset = CGPointMake(width, 0);
        self.pageControl.frame = CGRectMake(0, height - 20, width, 20);
        self.left.frame = CGRectMake(0, 0, width, height);
        self.middle.frame = CGRectMake(width, 0, width, height);
        self.right.frame = CGRectMake(width * 2, 0, width, height);
    }
    
    return self;
}

// 加载数据或者刷新数据
- (void)reloadData {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerItemCount)]) {
        self.count = [self.delegate bannerItemCount];
        self.scrollView.scrollEnabled = self.count <= 1 ? NO : YES;
        if (self.count <= 1) {
            self.leftIndex = 0;
            self.middleIndex = 0;
            self.rightIndex = 0;
        } else if (self.count > 1) {
            self.leftIndex = self.count - 1;
            self.middleIndex = 0;
            self.rightIndex = 1;
        }
        self.pageControl.hidden = self.count <= 1 ? YES : NO;
        self.pageControl.numberOfPages = self.count;
        self.pageControl.currentPage = self.middleIndex;
        // 更新显示
        [self updateShow];
        [self stop];
        [self start];
    }
}

// 更新显示
- (void)updateShow {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerItem:index:)]) {
        if (self.count == 0) {
            [self.delegate bannerItem:self.middle index:0];
        } else {
            [self.delegate bannerItem:self.left index:self.leftIndex];
            [self.delegate bannerItem:self.middle index:self.middleIndex];
            [self.delegate bannerItem:self.right index:self.rightIndex];
        }
    }
}

#pragma mark - SET/GET

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _left = [[BannerItem alloc] init];
        [_scrollView addSubview:_left];
        _middle = [[BannerItem alloc] init];
        [_scrollView addSubview:_middle];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
        [_middle addGestureRecognizer:tap];
        _right = [[BannerItem alloc] init];
        [_scrollView addSubview:_right];
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor lc_tint];
        _pageControl.pageIndicatorTintColor = [UIColor lc_backgroundColor225];
        _pageControl.enabled = NO;
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

#pragma mark - 手势处理

- (void)gestureHandler:(UIGestureRecognizer *)gesture {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerItemClicked:)]) {
        [self.delegate bannerItemClicked:self.middleIndex];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self start];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.scrollView.contentOffset.x == 0) {
        --self.leftIndex;
        --self.middleIndex;
        --self.rightIndex;
        if (self.leftIndex == -1) {
            self.leftIndex = self.count - 1;
        }
        if (self.middleIndex == -1) {
            self.middleIndex = self.count - 1;
        }
        if (self.rightIndex == -1) {
            self.rightIndex = self.count - 1;
        }
    } else if (self.scrollView.contentOffset.x == self.scrollView.bounds.size.width * 2) {
        ++self.leftIndex;
        ++self.middleIndex;
        ++self.rightIndex;
        if (self.leftIndex == self.count) {
            self.leftIndex = 0;
        }
        if (self.middleIndex == self.count) {
            self.middleIndex = 0;
        }
        if (self.rightIndex == self.count) {
            self.rightIndex = 0;
        }
    } else {
        return;
    }
    [self updateShow];
    self.pageControl.currentPage = self.middleIndex;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
}

#pragma mark - 自动滚动

- (void)start {
    
    if (self.count > 1) {
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:4
                                                          target:self
                                                        selector:@selector(processTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
        } else {
            [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4]];
        }
    }
}

- (void)stop {
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)processTimer:(NSTimer *)timer {
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * 2, 0)
                             animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.4
                                     target:self
                                   selector:@selector(scrollViewDidEndDecelerating:)
                                   userInfo:nil
                                    repeats:NO];
}

@end
