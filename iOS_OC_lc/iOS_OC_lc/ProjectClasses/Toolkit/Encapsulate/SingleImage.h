//
//  SingleImage.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

/* 图片单选和拍照 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SingleImageCompletion)(UIImage *image);
typedef void (^SingleImageCancel)(void);

@interface SingleImage : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 弹出列表，选择或拍照
- (void)singleImageOwner:(UIViewController *)owner
              completion:(SingleImageCompletion)completion
                  cancel:(SingleImageCancel)cancel;

@end

NS_ASSUME_NONNULL_END
