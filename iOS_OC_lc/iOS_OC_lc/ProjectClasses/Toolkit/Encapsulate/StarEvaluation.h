//
//  StarEvaluation.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^StarEvaluationResult)(CGFloat score);

@interface StarEvaluation : UIView

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
                       result:(StarEvaluationResult)result;

@end

NS_ASSUME_NONNULL_END
