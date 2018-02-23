//
//  UIImage+CornerRadius.h
//  ImageRadius
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

+(UIImage*)imageWithCornerRadius:(UIImage*)image withCornerRadius:(CGFloat)radius;

-(UIImage*)imageWithCornerRadius:(CGFloat)radius withSize:(CGSize)size;
@end
