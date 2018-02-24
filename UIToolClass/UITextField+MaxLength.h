//
//  UITextField+MaxLength.h
//  UITool
//
//  Created by apple on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MaxLength)


typedef void(^LimitBlock)(UITextField *textField);


@property (nonatomic,copy)LimitBlock limitBlock;
@property (nonatomic,assign)NSUInteger maxLenght;                  //限制文本长度，需要的时候直接设置数值，不需要的时候直接设置为0

@end
