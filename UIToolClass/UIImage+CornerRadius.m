//
//  UIImage+CornerRadius.m
//  ImageRadius
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

+(UIImage*)imageWithCornerRadius:(UIImage *)image withCornerRadius:(CGFloat)radius
{
    if(image)
    {
        return  [image imageWithCornerRadius:radius withSize:image.size];
    }
    
    return nil;
}

-(UIImage*)imageWithCornerRadius:(CGFloat)radius withSize:(CGSize)size
{
    CGRect rect = (CGRect){0.f,0.f,size};
    // void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
    //size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    //    opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    //    scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    //根据矩形画带圆角的曲线
//    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    [self drawInRect:rect];
    
    //图片缩放，是非线程安全的
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}



@end
