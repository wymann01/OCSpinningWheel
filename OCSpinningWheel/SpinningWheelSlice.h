//
//  SpinningWheelSlice.h
//  iOSKit
//
//  Created by wymann pan on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct StrokeInfo {
    UIColor *color;
    CGFloat width;
};

@protocol FortuneWheelSliceProtocol <NSObject>

@optional
// 绘制额外的图片
- (void)drawAdditionalGraphics:(CGContextRef)context circularSegmentHeight:(CGFloat)height radius:(CGFloat)radius sliceDegree:(CGFloat)sliceDegree;
@end


@interface SpinningWheelSlice : NSObject<FortuneWheelSliceProtocol>

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UIColor *backgroundColor;
@property (nonatomic, assign)CGFloat degree;
@property (nonatomic, assign)struct StrokeInfo stroke;
@property (nonatomic, assign)CGFloat offsetFromExterior;

@property (nonatomic, strong)NSMutableDictionary<NSAttributedStringKey, id> *textAttributes;
@property (nonatomic, assign)CGFloat fontSize;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, assign)UIFont *font;

- (instancetype)initWithDegree:(CGFloat)degree;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title Degree:(CGFloat)degree;

- (struct StrokeInfo)getStrokeInfo;


@end

NS_ASSUME_NONNULL_END
