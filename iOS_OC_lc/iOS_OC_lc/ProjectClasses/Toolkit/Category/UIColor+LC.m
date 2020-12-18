//
//  UIColor+LC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/12/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "UIColor+LC.h"

@implementation UIColor (LC)

#pragma mark - 背景颜色
+ (UIColor *)lc_black {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(0, 0, 0);
        }
    } else {
        return COLORRGB(0, 0, 0);
    }
}

+ (UIColor *)lc_white {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor blackColor];
        } else {
            return COLORRGB(255, 255, 255);
        }
    } else {
        return COLORRGB(255, 255, 255);
    }
}

+ (UIColor *)lc_backgroundColor245 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor blackColor];
        } else {
            return COLORRGB(245, 245, 245);
        }
    } else {
        return COLORRGB(245, 245, 245);
    }
}

+ (UIColor *)lc_backgroundColor235 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor blackColor];
        } else {
            return COLORRGB(235, 235, 235);
        }
    } else {
        return COLORRGB(235, 235, 235);
    }
}

+ (UIColor *)lc_backgroundColor225 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor blackColor];
        } else {
            return COLORRGB(225, 225, 225);
        }
    } else {
        return COLORRGB(225, 225, 225);
    }
}

+ (UIColor *)lc_line {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor blackColor];
        } else {
            return COLORRGB(220, 220, 220);
        }
    } else {
        return COLORRGB(220, 220, 220);
    }
}

#pragma mark - 文字颜色
+ (UIColor *)lc_textColor32 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(32, 32, 32);
        }
    } else {
        return COLORRGB(32, 32, 32);
    }
}

+ (UIColor *)lc_textColor51 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(51, 51, 51);
        }
    } else {
        return COLORRGB(51, 51, 51);
    }
}

+ (UIColor *)lc_textColor86 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(86, 86, 86);
        }
    } else {
        return COLORRGB(86, 86, 86);
    }
}

+ (UIColor *)lc_textColor102 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(102, 102, 102);
        }
    } else {
        return COLORRGB(102, 102, 102);
    }
}

+ (UIColor *)lc_textColor153 {
    
    if (@available(iOS 13.0, *)) {
        if (LCDarkMode) {
            return [UIColor whiteColor];
        } else {
            return COLORRGB(153, 153, 153);
        }
    } else {
        return COLORRGB(153, 153, 153);
    }
}

#pragma mark - APP 其他色
+ (UIColor *)lc_tint {
    
    return COLORRGB(210, 0, 22);
}

+ (UIColor *)lc_redUp {
    
    return COLORRGB(222, 48, 49);
}

+ (UIColor *)lc_greenDown {
    
    return COLORRGB(84, 165, 56);
}

+ (UIColor *)lc_blueDark {
    
    return COLORRGB(25, 102, 176);
}

@end
