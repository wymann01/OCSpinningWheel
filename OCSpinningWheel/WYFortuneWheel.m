//
//  WYFortuneWheel.m
//  转盘 View
//  iOSKit
//
//  Created by wymann pan on 2023/10/23.
//

#import "WYFortuneWheel.h"
#import "FortuneWheelLayer.h"


@implementation WYFortuneWheel

- (instancetype)initWithFrame:(CGRect)frame slices:(NSArray<SpinningWheelSlice *> *)slices {
    self = [super initWithFrame:frame];
    if(self) {
        self.slices = slices;
    }
    self.equalSlices = NO;
    [self setBackgroundColor:UIColor.blueColor];
    return self;
}

- (void)addWheelLayer {
    _wheelLayer = [[FortuneWheelLayer alloc] initWithFrame:self.bounds parent:self initialOffset:_initialDrawingOffset];
    [self.layer addSublayer:_wheelLayer];
    [_wheelLayer setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 移除旧的 layer
    FortuneWheelLayer *oldLayer = self.wheelLayer;
    if(oldLayer) {
        [oldLayer removeFromSuperlayer];
    }
    [self addWheelLayer];

    // 校验扇形的整体角度
    NSAssert([self sliceInfoIsValid],  @"All slices must have a 360 degree combined. Set equalSlices true if you want to distribute them evenly.");
    if(self.equalSlices) {
        self.sliceDegree = 360 / self.slices.count;
    }
}

- (BOOL)sliceInfoIsValid {
    if(self.equalSlices) {
        return YES;
    }
    
    CGFloat sum = 0;
    for (int i = 0; i < self.slices.count; i++) {
        sum += self.slices[i].degree;
    }
    
    return sum == 360;
}

- (void)startAnimatingFinishIndex:(NSUInteger)index completion:(void (^)(void))completion {
    // 计算出实际相差的旋转偏移量
    CGFloat offset = 360 - [self calculateRadianForIndex:index];
    
    CGFloat fullRotationsUntilFinish = 6;// 结束旋转前,要转多少圈
    CGFloat adjustmentOffset = -90; // 为了让底部正好指向当前 index 代表的扇形, 添加一个调整的偏移量
    CGFloat rotationOffset = fullRotationsUntilFinish * 360 + offset + adjustmentOffset;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@0, @(rotationOffset * M_PI / 180)];
    animation.keyTimes = @[@0, @1];
    animation.duration = 3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    NSString *animationKey = @"starRotationAnim";
    if(completion) {
        self.rotaryEndTurnBlock = completion;
    }
    [self.wheelLayer addAnimation:animation forKey:animationKey];
}

- (CGFloat)calculateRadianForIndex:(NSUInteger)finishIndex {
    finishIndex = finishIndex % _slices.count;
    NSLog(@"当前 finishIndex = %lu", finishIndex);
    if (self.equalSlices) {
        return finishIndex * _sliceDegree;
    }
    __block CGFloat radianSum = 0.0f;
    
    [_slices enumerateObjectsUsingBlock:^(SpinningWheelSlice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < finishIndex) {
            radianSum += obj.degree;
        }
    }];
    
    return radianSum;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *keypath = @"transform.rotation.z";
    [self.layer setValue:[self.layer.presentationLayer valueForKeyPath:keypath] forKeyPath:keypath];
    [self.layer removeAllAnimations];
    if(self.rotaryEndTurnBlock) {
        self.rotaryEndTurnBlock();
    }
}



@end
