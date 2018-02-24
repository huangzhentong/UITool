//
//  UITextField+MaxLength.m
//  UITool
//
//  Created by apple on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>
@implementation UITextField (MaxLength)


- (void)setLimitBlock:(LimitBlock)limitBlock {
    objc_setAssociatedObject(self, @selector(limitBlock), limitBlock, OBJC_ASSOCIATION_COPY);
    
    if (limitBlock) {
        [self removeTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (LimitBlock)limitBlock {
    return objc_getAssociatedObject(self, @selector(limitBlock));
}

-(void)setMaxLenght:(NSUInteger)maxLenght
{
    objc_setAssociatedObject(self,@selector(maxLenght), @(maxLenght), OBJC_ASSOCIATION_ASSIGN);
    [self removeTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    if(maxLenght>0)
       
        [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
-(NSUInteger)maxLenght
{
    return  [(NSNumber*) objc_getAssociatedObject(self, @selector(maxLenght)) unsignedIntegerValue];
    
}

//- (void)lengthLimit:(LimitBlock)limit {
//    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.limitBlock = limit;
//}

- (void)textFieldEditChanged:(UITextField *)textField {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    
    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            [self textDispose];
            
            
        }
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self textDispose];
        
        
    }
    
}
-(void)textDispose
{
    if (self.maxLenght > 0) {
        if (self.text.length > self.maxLenght) {
            NSRange rg = {0,MAX(self.maxLenght,0)};
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [self.text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [self.text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [self.text enumerateSubstringsInRange:NSMakeRange(0, [self.text length])
                                              options:NSStringEnumerationByComposedCharacterSequences
                                           usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                               
                                               if (idx >= rg.length) {
                                                   *stop = YES; //取出所需要就break，提高效率
                                                   return ;
                                               }
                                               
                                               trimString = [trimString stringByAppendingString:substring];
                                               
                                               idx++;
                                           }];
                
                s = trimString;
            }
            self.text = s;
            if (self.limitBlock) {
                self.limitBlock(self);
            }
        }
    }
    else
    {
        if (self.limitBlock) {
            self.limitBlock(self);
        }
    }
}

@end
