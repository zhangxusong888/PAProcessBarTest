//
//  PAProcessView.h
//  PAProcessBarTest
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAProcessView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                      process:(CGFloat)process
                       prefix:(NSString *)prefix
                       suffix:(NSString *)suffix;
- (void)updateProcess:(CGFloat)process;

@end
