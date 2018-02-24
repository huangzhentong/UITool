//
//  UITextView+MaxLength.h
//  UITool
//
//  Created by apple on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TextViewLimitBlock)(UITextView *textView);
@interface UITextView (MaxLength)
@property (nonatomic,copy)TextViewLimitBlock limitBlock;
@property(nonatomic,assign)NSUInteger maxLenght;
@end
