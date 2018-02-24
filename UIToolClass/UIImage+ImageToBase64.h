//
//  UIImage+ImageToBase64.h
//  SadjAppClient
//
//  Created by 送爱到家 on 2017/11/8.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageToBase64)
//图片转base64
- (NSString *) imageToData64URL;

+(NSString*)imageCompressionToBase64:(id)context maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;
@end
