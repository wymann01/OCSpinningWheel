//
//  SpinningWheelSlice.m
//  iOSKit
//
//  Created by wymann pan on 2023/10/27.
//

#import "SpinningWheelSlice.h"


@implementation SpinningWheelSlice

- (instancetype)initWithDegree:(CGFloat)degree {
    return [self initWithTitle:@"" Degree:degree];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title Degree:0];
}

- (instancetype)initWithTitle:(NSString *)title Degree:(CGFloat)degree {
    self = [super init];
    if(self) {
        self.title = title;
        self.degree = degree;
        self.offsetFromExterior = 10.0f;
    }
    return self;
}

// 定义边框颜色和宽度
- (struct StrokeInfo)getStrokeInfo {
    struct StrokeInfo info;
    info.width = 1.0;
    info.color = UIColor.whiteColor;
    return info;
}

@end
