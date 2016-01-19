//
//  ViewController.m
//  PAProcessBarTest
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "PAProcessView.h"

@interface ViewController ()

@property (assign, nonatomic) CGFloat process;
@property (strong, nonatomic) PAProcessView *processView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addProcessView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (IBAction)testButtonTouched:(UIButton *)sender {
    self.process += 13;
    [self.processView updateProcess:self.process];
}

// MARK: Private Functions
- (void)addProcessView {
    CGRect frame =  CGRectMake(20, 100, 360, 200);
    self.process = 11;
    NSString *prefix = @"募集";
    NSString *suffix = @"%";
    
    PAProcessView *processView = [[PAProcessView alloc] initWithFrame:frame process:self.process prefix:prefix suffix:suffix];
    processView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:processView];
    self.processView = processView;
}

@end
