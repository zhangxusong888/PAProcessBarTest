//
//  PAProcessView.m
//  PAProcessBarTest
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "PAProcessView.h"
#import <UIKit/UIKit.h>
#import "PATheme.h"

// process value
#define kProcessMin                  0
#define kProcessMax                  100
// process bar
#define kProcessHeight               8
#define kGrayProcessColor            0xcccccc
// trigle
#define kTriangleOffset              6
#define KTriangleWidth               12
#define kTriangleHeight              8
#define kTriangleColor               0xff0000
// label
#define kInfoLabelWidth              50
#define kInfoLabelHeight             20
#define kInfoLabelTextColor          0xffffff
#define kInfoLabelBackgroundColor    0xff0000
#define kInfoLabelFontSize           10
#define kInfoLabelCornerRadius       3
// layer
#define kStartColor                  0xffff88
#define kEndLineColor                0xff8888
// margin
#define kMarginLeft                  (kInfoLabelWidth / 2)
#define kMarginRight                 (kInfoLabelWidth / 2)
#define kMarginBottom                10
// min max
#define kFrameMinWidth               (kMarginLeft + kMarginRight + (kInfoLabelWidth * 2))
#define kFrameMinHeight              (kMarginBottom + kProcessHeight + kTriangleOffset + kTriangleHeight + kInfoLabelHeight)

@interface PAProcessView ()

@property (assign, nonatomic) CGFloat process;
@property (assign, nonatomic) CGFloat processXValue;
@property (copy, nonatomic) NSString *prefix;
@property (copy, nonatomic) NSString *suffix;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAShapeLayer *maskLayer;

@end

@implementation PAProcessView

// MARK: Public Interface Functions
- (instancetype)initWithFrame:(CGRect)frame
                      process:(CGFloat)process
                       prefix:(NSString *)prefix
                       suffix:(NSString *)suffix {
    self = [super initWithFrame:frame];
    if (self) {
        // 默认是黑色，改为透明色
        self.backgroundColor = [UIColor clearColor];
        // frame
        CGFloat width = MAX(frame.size.width, kFrameMinWidth);
        CGFloat height = MAX(frame.size.height, kFrameMinHeight);
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, height);
        // process
        if (process > kProcessMax) {
            self.process = kProcessMax;
        } else if (process < kProcessMin) {
            self.process = kProcessMin;
        } else {
            self.process = process;
        }
        [self processToFrameXValue];
        
        // prefix, suffix
        if (nil == prefix) {
            self.prefix = @"";
        } else {
            self.prefix = [NSString stringWithString:prefix];
        }
        if (nil == suffix) {
            self.suffix = @"";
        } else {
            self.suffix = [NSString stringWithString:suffix];
        }
        // info label
        [self addProcessInfoLabel];
        // layer
        [self addPrcessBarLayers];
    }
    return self;
}

- (void)updateProcess:(CGFloat)process {
    if (process > kProcessMax) {
        self.process = kProcessMax;
    } else if (process < kProcessMin) {
        self.process = kProcessMin;
    } else {
        self.process = process;
    }
    [self processToFrameXValue];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawGrayProcess];
    [self drawTriangle];
    [self adjustInfoLabel];
    [self adjustProcessPath];
}

// MARK: Private Functions
- (void)drawGrayProcess {
    CGFloat x = kMarginLeft;
    CGFloat y = self.bounds.size.height - kMarginBottom - kProcessHeight;
    CGFloat width = self.bounds.size.width - kMarginLeft - kMarginRight;
    CGFloat height = kProcessHeight;
    CGFloat cornerRadius = kProcessHeight / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width, height) cornerRadius:cornerRadius];
    UIColor *fillColor = UIColorFromRGB(kGrayProcessColor);
    [fillColor setFill];
    [path fill];
}

- (void)drawTriangle {
    CGFloat x = self.processXValue;
    CGFloat y = self.bounds.size.height - kMarginBottom - kProcessHeight - kTriangleOffset;
    CGPoint point1 = CGPointMake(x, y);
    
    x = point1.x - (KTriangleWidth / 2);
    y = point1.y - kTriangleHeight;
    CGPoint point2 = CGPointMake(x, y);
    
    x = point2.x + KTriangleWidth;
    y = point2.y;
    CGPoint point3 = CGPointMake(x, y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path closePath];
    UIColor *fillColor = UIColorFromRGB(kTriangleColor);
    [fillColor setFill];
    [path fill];
}

- (void)adjustInfoLabel {
    NSString *info = [NSString stringWithFormat:@"%@%0.0f%@", self.prefix, self.process, self.suffix];
    self.infoLabel.text = info;
    self.infoLabel.font = [UIFont systemFontOfSize:kInfoLabelFontSize];
    self.infoLabel.textColor = UIColorFromRGB(kInfoLabelTextColor);
    self.infoLabel.backgroundColor = UIColorFromRGB(kInfoLabelBackgroundColor);
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat x = self.processXValue - (kInfoLabelWidth / 2);
    CGFloat y = self.bounds.size.height - kMarginBottom - kProcessHeight - kTriangleOffset - kTriangleHeight - kInfoLabelHeight;
    self.infoLabel.frame = CGRectMake(x, y, kInfoLabelWidth, kInfoLabelHeight);
    self.infoLabel.layer.cornerRadius = kInfoLabelCornerRadius;
    self.infoLabel.layer.masksToBounds = YES;
}

- (void)adjustProcessPath {
    CGFloat x = kMarginLeft;
    CGFloat y = self.bounds.size.height - kMarginBottom - kProcessHeight;
    CGFloat width = self.processXValue - kMarginLeft;
    CGFloat height = kProcessHeight;
    CGFloat cornerRadius = kProcessHeight / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width, height) cornerRadius:cornerRadius];
    self.maskLayer.path = path.CGPath;
}

- (void)processToFrameXValue {
    CGFloat step = (self.bounds.size.width - kMarginLeft - kMarginRight) / (kProcessMax - kProcessMin);
    self.processXValue = kMarginLeft + kProcessMin + ((self.process - kProcessMin) * step);
}

- (void)addProcessInfoLabel {
    if (nil == self.infoLabel) {
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    [self.infoLabel removeFromSuperview];
    [self addSubview:self.infoLabel];
}

- (void)addPrcessBarLayers {
    // gradientLayer
    if (nil == self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
    }
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.colors = @[(__bridge id)[UIColorFromRGB(kStartColor) CGColor],
                    (__bridge id)[UIColorFromRGB(kEndLineColor) CGColor]];
    //maskLayer
    if (nil == self.maskLayer) {
        self.maskLayer = [CAShapeLayer layer];
    }
    self.maskLayer.frame = self.bounds;
    
    self.gradientLayer.mask = self.maskLayer;
    [self.gradientLayer removeFromSuperlayer];
    [self.layer addSublayer:self.gradientLayer];
}

@end
