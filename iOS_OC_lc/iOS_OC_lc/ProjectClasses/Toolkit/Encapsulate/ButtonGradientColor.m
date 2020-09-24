//
//  ButtonGradientColor.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "ButtonGradientColor.h"

@interface ButtonGradientColor ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CALayer *bgLayer;

@end

@implementation ButtonGradientColor

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)config {
    
    self.radius = 0;
    self.bgColor = [UIColor lightGrayColor];
    self.startColor = [UIColor lightGrayColor];
    self.endColor = [UIColor darkGrayColor];
    self.isHorizontal = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    
    self.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.radius;
    self.layer.backgroundColor = self.bgColor.CGColor;
    if (self.enabled) {
        if (self.currentImage) {
            [self.layer insertSublayer:self.gradientLayer below:self.imageView.layer];
        } else {
            [self.layer insertSublayer:self.gradientLayer below:self.titleLabel.layer];
        }
    } else {
        [self.layer insertSublayer:self.bgLayer below:self.titleLabel.layer];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"gradientLayer"] || [layer.name isEqualToString:@"bglayer"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
}

#pragma mark - SET/GET

- (CALayer *)bgLayer {
    
    if (_bgLayer == nil) {
        _bgLayer = [CALayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.name = @"bglayer";
        _bgLayer.backgroundColor = self.bgColor.CGColor;
        _bgLayer.cornerRadius = self.radius;
    }
    
    return _bgLayer;
}

- (CAGradientLayer *)gradientLayer {
    
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.name = @"gradientLayer";
        _gradientLayer.colors = @[(__bridge id)self.startColor.CGColor,
                                  (__bridge id)self.endColor.CGColor];
        _gradientLayer.locations = @[@0.0, @1.0];
        if (self.isHorizontal) {
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(1.0, 0);
        } else {
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(0, 1.0);
        }
        _gradientLayer.frame = self.bounds;
        _gradientLayer.cornerRadius = self.radius;
    }
    
    return _gradientLayer;
}

@end
