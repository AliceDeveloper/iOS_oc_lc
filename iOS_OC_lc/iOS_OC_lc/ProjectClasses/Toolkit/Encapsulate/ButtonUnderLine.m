//
//  ButtonUnderLine.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "ButtonUnderLine.h"

@implementation ButtonUnderLine

- (instancetype)init {
    
    return [super init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    return [super initWithCoder:aDecoder];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect textRect = self.titleLabel.frame;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    CGFloat x = textRect.origin.x;
    CGFloat y = textRect.origin.y + textRect.size.height * 1.1;
    CGContextMoveToPoint(contextRef, x, y);
    CGContextAddLineToPoint(contextRef, x + textRect.size.width, y);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
