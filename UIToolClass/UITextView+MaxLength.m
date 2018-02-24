//
//  UITextView+MaxLength.m
//  UITool
//
//  Created by apple on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UITextView+MaxLength.h"
#import <objc/runtime.h>
@implementation UITextView (MaxLength)


+(void)initialize
{
    Method origMethod = class_getInstanceMethod([self class], @selector(removeFromSuperview));
    SEL origsel = @selector(removeFromSuperview);
    Method swizMethod = class_getInstanceMethod([self class], @selector(h_removeFromSuperview));
    SEL swizsel = @selector(h_removeFromSuperview);
    BOOL addMehtod = class_addMethod([self class], origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (addMehtod)
    {
        class_replaceMethod([self class], swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    
    else
    {
        method_exchangeImplementations(origMethod, swizMethod);
    }
}
-(void)h_removeFromSuperview
{
    [self h_removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setLimitBlock:(TextViewLimitBlock)limitBlock
{
    objc_setAssociatedObject(self, @selector(limitBlock), limitBlock, OBJC_ASSOCIATION_COPY);
    
    if (limitBlock) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
}

-(TextViewLimitBlock)limitBlock
{
    return objc_getAssociatedObject(self, @selector(limitBlock));
}

-(void)setMaxLenght:(NSUInteger)maxLenght
{
    objc_setAssociatedObject(self, @selector(maxLenght), @(maxLenght), OBJC_ASSOCIATION_ASSIGN);

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (maxLenght>0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
}



-(NSUInteger)maxLenght
{
    return [(NSNumber*) objc_getAssociatedObject(self, @selector(maxLenght)) unsignedIntegerValue];
}


-(void)textViewDidChange:(NSNotification*)notificate
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    
    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
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
