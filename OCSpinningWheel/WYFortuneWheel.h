//
//  WYFortuneWheel.h
//  iOSKit
//
//  Created by wymann pan on 2023/10/23.
//

#import <UIKit/UIKit.h>
#import "SpinningWheelSlice.h"
//#import "FortuneWheelLayer.h"

NS_ASSUME_NONNULL_BEGIN

@class FortuneWheelLayer;

@interface WYFortuneWheel : UIControl<CAAnimationDelegate>

// 所有扇形角度是否相等
@property (nonatomic, assign)BOOL equalSlices;
// 所有扇形的数据
@property (nonatomic, strong)NSArray<SpinningWheelSlice *> *slices;
@property (nonatomic, assign)CGFloat initialDrawingOffset;
@property (nonatomic, assign)CGFloat sliceDegree;
// 旋转完成后的回调 block
@property (nonatomic, copy) void (^rotaryEndTurnBlock)(void);

@property (nonatomic, strong)FortuneWheelLayer *wheelLayer;

- (instancetype)initWithFrame:(CGRect)frame slices:(NSArray<SpinningWheelSlice *> *)slices;

- (void)startAnimatingFinishIndex:(NSUInteger)index completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
