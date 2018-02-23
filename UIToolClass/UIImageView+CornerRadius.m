//
//  UIImageView+CornerRadius.m
//  ImageRadius
//
//  Created by apple on 2018/2/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIImageView+CornerRadius.h"
#import "UIImage+CornerRadius.h"
@implementation UIImageView (CornerRadius)
-(void)imageWithCornerRadius:(CGFloat)radius
{
    UIImage *image = self.image;
    CGSize size = self.bounds.size;
    //异步绘制圆角
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *raduisImage =  [image imageWithCornerRadius:radius withSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = raduisImage;
        });
    });
}
@end
