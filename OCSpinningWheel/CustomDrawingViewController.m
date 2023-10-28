//
//  CustomDrawingViewController.m
//  iOSKit
//
//  Created by wymann pan on 2023/10/23.
//

#import "CustomDrawingViewController.h"
#import "WYFortuneWheel.h"
#import "SpinningWheelSlice.h"

@interface CustomDrawingViewController()

@property (nonatomic, strong)WYFortuneWheel *wheel;

@end


@implementation CustomDrawingViewController

- (void)viewDidLoad {
    [self.view setBackgroundColor:UIColor.whiteColor];
    NSArray<SpinningWheelSlice *> *slices = @[
        [[SpinningWheelSlice alloc] initWithTitle:@"Roller Coaster" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"再试一次" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"Free\nticket" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"Teddy\nbear" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"Large popcorn" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"Balloon figures" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"1111 9999" Degree:90],
        [[SpinningWheelSlice alloc] initWithTitle:@"测试中文数据" Degree:90],
    ];
    CGFloat screenWidth = self.view.bounds.size.width;
    
    WYFortuneWheel *wheel = [[WYFortuneWheel alloc] initWithFrame:CGRectMake(20, 200, screenWidth - 40, screenWidth - 40) slices:slices];
    wheel.equalSlices = YES;
    self.wheel = wheel;
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [wheel addGestureRecognizer:gr];
    [self.view addSubview:wheel];
}

- (void)onClick {
    NSUInteger selectIndex = 5;
    NSUInteger saveIndex = selectIndex % self.wheel.slices.count;
    [self.wheel startAnimatingFinishIndex:saveIndex completion:^(void) {
        // 转盘结束转动
        NSString *selectSliceTitle = self.wheel.slices[saveIndex].title;
        NSLog(@"当前选中了 %@", selectSliceTitle);
        [self showSelectMessage:selectSliceTitle];
    }];
}

- (void)showSelectMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前选中了" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
