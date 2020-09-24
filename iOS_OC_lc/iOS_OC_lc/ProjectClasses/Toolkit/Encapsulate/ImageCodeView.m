//
//  ImageCodeView.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/9/3.
//  Copyright © 2020 lc. All rights reserved.
//

#import "ImageCodeView.h"

#define CODE_COUNT 4 // 需要生成的验证码位数
#define ARC4RAND_MAX 0x100000000

@interface ImageCodeView ()

@property (nonatomic, strong) UIView *bgView; // 背景
@property (nonatomic, strong) NSArray *arrCode; // 验证码数据源
@property (nonatomic, strong) NSString *strCode; // 验证码
@property (nonatomic, assign) ImageCodeType type; // 类型

@end

@implementation ImageCodeView

// 初始化视图
- (instancetype)initWithFrame:(CGRect)frame type:(ImageCodeType)type {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setType:type];
        [self refreshImageCode];
    }
    
    return self;
}

// 刷新图片验证码
- (void)refreshImageCode {
    
    self.strCode = @"";
    for (NSInteger i = 0; i < CODE_COUNT; i++) {
        NSInteger index = arc4random() % (self.arrCode.count - 1);
        self.strCode = [NSString stringWithFormat:@"%@%@", self.strCode, self.arrCode[index]];
    }
    if (self.imageCodeBlock) {
        self.imageCodeBlock(self.strCode);
    }
    
    [self createImageCode];
}

// 构建视图
- (void)createImageCode {
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:arc4random() % 100 / 100.0
                                                  green:arc4random() % 100 / 100.0
                                                   blue:arc4random() % 100 / 100.0
                                                  alpha:0.4];
    [self addSubview:self.bgView];
    
    NSInteger width = self.bounds.size.width;
    NSInteger height = self.bounds.size.height;
    
    CGSize textSize = [@"W" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    NSInteger randWidth = width / self.strCode.length - textSize.width;
    NSInteger randHeight = height - textSize.height;
    
    for (NSInteger i = 0; i < self.strCode.length; i++) {
        CGFloat px = arc4random() % randWidth + i * (width - 3) / self.strCode.length;
        CGFloat py = arc4random() % randHeight;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(px + 3, py, textSize.width, textSize.height)];
        label.text = [NSString stringWithFormat:@"%C", [self.strCode characterAtIndex:i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        
        double r = (double)arc4random() / ARC4RAND_MAX * 2 - 1.0f; // 随机-1到1
        if (r > 0.4) {
            r = 0.4;
        } else if (r < -0.4) {
            r = -0.4;
        }
        label.transform = CGAffineTransformMakeRotation(r);
        
        [self.bgView addSubview:label];
    }
    
    for (NSInteger i = 0; i < 100; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(arc4random() % width, arc4random() % height)];
        [path addLineToPoint:CGPointMake(arc4random() % width, arc4random() % height)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithRed:arc4random() % 100 / 100.0
                                            green:arc4random() % 100 / 100.0
                                             blue:arc4random() % 100 / 100.0
                                            alpha:0.1].CGColor;
        layer.lineWidth = 1.0f;
        layer.strokeEnd = 1;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [self.bgView.layer addSublayer:layer];
    }
}

#pragma mark - SET/GET

- (void)setType:(ImageCodeType)type {
    
    _type = type;
    switch (_type) {
        case ImageCodeType_Default:
            self.arrCode = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                             @"a", @"b", @"c", @"d", @"e", @"f", @"g",
                             @"h", @"i", @"j", @"k", @"l", @"m", @"n",
                             @"o", @"p", @"q", @"r", @"s", @"t",
                             @"u", @"v", @"w", @"x", @"y", @"z",
                             @"A", @"B", @"C", @"D", @"E", @"F", @"G",
                             @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                             @"O", @"P", @"Q", @"R", @"S", @"T",
                             @"U", @"V", @"W", @"X", @"Y", @"Z"];
            break;
        case ImageCodeType_Number:
            self.arrCode = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
            break;
        case ImageCodeType_Letter:
            self.arrCode = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g",
                             @"h", @"i", @"j", @"k", @"l", @"m", @"n",
                             @"o", @"p", @"q", @"r", @"s", @"t",
                             @"u", @"v", @"w", @"x", @"y", @"z",
                             @"A", @"B", @"C", @"D", @"E", @"F", @"G",
                             @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                             @"O", @"P", @"Q", @"R", @"S", @"T",
                             @"U", @"V", @"W", @"X", @"Y", @"Z"];
            break;
        default:
            break;
    }
}

@end
