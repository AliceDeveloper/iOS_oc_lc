//
//  StarEvaluation.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "StarEvaluation.h"

static CGFloat LCStarCount = 5;

@interface StarEvaluation ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy  ) StarEvaluationResult result;

@end

@implementation StarEvaluation

/**
 五星评价：初始化显示
 
 @param frame       评分视图frame
 @param fore        显示在前面图片名称
 @param back        显示在后面图片名称
 @param originScore 初始化显示范围0-1，默认1
 @param isEdit      YES 表示允许五星评分操作，NO 表示五星评分显示，不能操作
 @param result      评分结果，范围0-1
 
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                         fore:(NSString *)fore
                         back:(NSString *)back
                  originScore:(CGFloat)originScore
                       isEdit:(BOOL)isEdit
                       result:(StarEvaluationResult)result {
    
    self = [super initWithFrame:frame];
    if (self) {
        if (originScore > 1) {
            originScore = 1;
        } else if (originScore < 0) {
            originScore = 0;
        }
        _isEdit = isEdit;
        _result = result;
        _backgroundView = [self buidlStarViewWithImageName:back score:1];
        _foregroundView = [self buidlStarViewWithImageName:fore score:originScore];
        [self addSubview:_backgroundView];
        [self addSubview:_foregroundView];
    }
    
    return self;
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName score:(CGFloat)score {
    
    CGFloat width = CGRectGetWidth(self.bounds) * score;
    CGFloat height = CGRectGetHeight(self.bounds);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.layer.masksToBounds = YES;
    
    width = CGRectGetWidth(self.bounds) / LCStarCount;
    for (NSInteger i = 0; i < LCStarCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
    }
    
    return view;
}

#pragma mark - 触摸事件

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf changeStarForegroundViewWithPoint:point];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf changeStarForegroundViewWithPoint:point];
    }];
}

#pragma mark - 通过坐标改变前景视图

- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    
    if (_isEdit == NO) {
        return;
    }
    
    if (point.x >= 0 && point.x <= self.frame.size.width) {
        CGFloat score = ceil(point.x / self.frame.size.width * 10) / 10;
        point.x = score * self.frame.size.width;
        _foregroundView.frame = CGRectMake(0, 0, point.x, self.frame.size.height);
        if (_result) {
            _result(score);
        }
    }
}

@end
