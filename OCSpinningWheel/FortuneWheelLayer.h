//
//  FortuneWheelLayer.h
//  iOSKit
//
//  Created by wymann pan on 2023/10/27.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "WYFortuneWheel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FortuneWheelLayer : CALayer

@property (nonatomic, assign)UIEdgeInsets layerInsets;
@property (nonatomic, assign)CGRect mainFrame;
@property (nonatomic, weak)WYFortuneWheel *parent;
@property (nonatomic, assign)CGFloat initialOffset;

- (instancetype)initWithFrame:(CGRect)frame parent:(WYFortuneWheel *)parent initialOffset:( CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
