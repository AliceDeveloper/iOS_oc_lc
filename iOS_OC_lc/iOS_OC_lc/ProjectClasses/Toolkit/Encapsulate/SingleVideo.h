//
//  SingleVideo.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

/* 视频单选和拍摄 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SingleVideoCompletion)(NSString *videoPath);
typedef void (^SingleVideoCancel)(void);

@interface SingleVideo : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 弹出列表，选择或拍摄
- (void)singleVideoOwner:(UIViewController *)owner
              completion:(SingleVideoCompletion)completion
                  cancel:(SingleVideoCancel)cancel;

@end

NS_ASSUME_NONNULL_END
