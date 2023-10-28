//
//  FortuneWheelLayer.m
//  iOSKit
//
//  Created by wymann pan on 2023/10/27.
//

#import "FortuneWheelLayer.h"
#import "SpinningWheelSlice.h"

@interface FortuneWheelLayer ()

@property(nonatomic, assign)CGFloat rotationOffset;
@property(nonatomic, assign)CGFloat radius;

@end

@implementation FortuneWheelLayer

-(instancetype)initWithFrame:(CGRect)frame parent:(WYFortuneWheel *)parent initialOffset:( CGFloat)offset {
    self = [super init];
    
    if(self) {
//        _layerInsets = UIEdgeInsetsMake(-50, -50, -50, -50);
        _mainFrame = CGRectMake(fabs(_layerInsets.left), fabs(_layerInsets.top), frame.size.width, frame.size.height);
        self.frame = frame;
        self.parent = parent;
        if(!offset) {
            offset = 0.0;
        }
        self.initialOffset = offset;
        self.backgroundColor = UIColor.clearColor.CGColor;
        self.contentsScale = UIScreen.mainScreen.scale;
        
//        _rotationOffset = (frame.size.width) / 2 + fabs(_layerInsets.top);// 参考写法,但是发现是偏的
        _rotationOffset = (frame.size.width) / 2;
        _radius = frame.size.height / 2;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    NSAssert(_parent.slices != nil, @"Slices parameter not set.");
    UIGraphicsPushContext(ctx);
    [self drawCanvas];
    UIGraphicsPopContext();
}

- (void)drawCanvas {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    // 创建一个透明层,开始绘制 + 合成
    CGContextBeginTransparencyLayer(context, nil);
    
    __block CGFloat rotation = _initialOffset;
    [_parent.slices enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SpinningWheelSlice *element = (SpinningWheelSlice *)obj;
        if(idx > 0) {
            SpinningWheelSlice *preSlice = _parent.slices[idx - 1];
            rotation += ([self degreeForSlice:preSlice] + [self degreeForSlice:element]) / 2;
        }
        [self drawSliceIndex:idx context:context slice:element rotation:rotation];
    }];
    
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
}

- (void)drawSliceIndex:(NSUInteger)index context:(CGContextRef)context slice:(SpinningWheelSlice *)slice rotation:(CGFloat)rotation {
    
    CGFloat sectionWidthDegrees = [self degreeForSlice:slice];
    CGFloat startAngle = 180 + sectionWidthDegrees / 2.0;
    CGFloat endAngle = 180 - sectionWidthDegrees / 2.0;
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, self.rotationOffset, self.rotationOffset);
    CGContextRotateCTM(context, rotation * M_PI / 180);
    
    // 绘制背景形状
    CGRect sliceRect = CGRectMake(CGRectGetMinX(_mainFrame) - _rotationOffset, CGRectGetMinY(_mainFrame) - _rotationOffset, _mainFrame.size.width, _mainFrame.size.height);
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(sliceRect) , CGRectGetMidY(sliceRect)) radius:sliceRect.size.width / 2 startAngle:-startAngle * M_PI / 180 endAngle:-endAngle * M_PI / 180  clockwise:YES];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(sliceRect), CGRectGetMidY(sliceRect))];
    [path closePath];
    if(index % 2 == 0) {
        slice.backgroundColor = UIColor.systemYellowColor;
    } else {
        slice.backgroundColor = UIColor.systemPinkColor;
    }
    [slice.backgroundColor setFill];
    [path fill];
    
    // 绘制边框
    struct StrokeInfo info = [slice getStrokeInfo];
    [info.color setStroke];
    path.lineWidth = info.width;
    [path stroke];
    
    // 绘制文字
    CGFloat kTitleOffset = slice.offsetFromExterior;
    CGFloat titleXValue = CGRectGetMinX(_mainFrame) + kTitleOffset;
    CGFloat circularSegmentHeight = 2 * _radius * sin(sectionWidthDegrees / 2.0 * M_PI / 180);

    CGFloat kTitleWidth = 0.6;
    CGFloat titleWidthCoeficient = sin(sectionWidthDegrees / 2.0 * M_PI / 180);
    
        // 文本区域的宽高 + 位置
    CGFloat titleHeightValue = circularSegmentHeight;
    CGFloat titleWidthValue = (kTitleWidth + titleWidthCoeficient * 0.2) * _radius;
    
    CGFloat titleYPosition = CGRectGetMinY(_mainFrame) + _mainFrame.size.height / 2.0 - titleHeightValue / 2.0;
    
    
    CGRect textRect = CGRectMake(titleXValue - _rotationOffset, titleYPosition - _rotationOffset, titleWidthValue, titleHeightValue);
    NSString *titleContent = slice.title;
    
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentLeft;
    
    
    NSDictionary *textFontAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor,
                                        NSFontAttributeName: [UIFont systemFontOfSize:24],
                                        NSParagraphStyleAttributeName:style};
    CGRect textBoundingRect = [titleContent
                               boundingRectWithSize:CGSizeMake(textRect.size.width, CGFLOAT_MAX)
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes: textFontAttributes
                               context:nil];
    
    CGFloat textBoundingHeight = textBoundingRect.size.height;
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (textRect.size.height - textBoundingHeight) / 2 );
    
    CGContextClipToRect(context, CGRectMake(0, 0, textRect.size.width, textRect.size.height));
    
    [titleContent drawInRect:CGRectMake(0, 0, textRect.size.width, textBoundingHeight) withAttributes:textFontAttributes];
    CGContextRestoreGState(context);

    
    CGContextRestoreGState(context);
}

- (CGFloat)degreeForSlice:(SpinningWheelSlice *)slice {
    return self.parent.sliceDegree ?: slice.degree;
}


@end
