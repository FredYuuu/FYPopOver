//
//  ViewController.m
//  FYPopover
//
//  Created by Yu Haoran on 16/10/12.
//  Copyright © 2016年 Fred Yu. All rights reserved.
//

#import "ViewController.h"
#import "FYPopoverView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.button1 addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)popover:(UIButton *)button {
    FYPopoverView *popView = [FYPopoverView new];
    popView.menuTitles = @[@"Hey! I'm a popover"];
    [popView showFromView:button selected:^(NSInteger index) {
        ;
    }];
}

- (void)dealloc {
    [self.button1 removeTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
}

@end
