//
//  PublicCache.m
//  OperationalSystem
//
//  Created by KT--stc08 on 2019/3/26.
//  Copyright © 2019 KT--stc08. All rights reserved.
//

#import "PublicCache.h"

@implementation PublicCache
+(void)removeCache:(NSArray*)filterArray{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
   
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *path in files){
        NSError*error;
        
        NSString*targetPath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:targetPath])
        {
            NSArray *array = [path componentsSeparatedByString:@"/"];
            NSString *fistPath = array?[array firstObject]:path;
            if(filterArray != nil)
            {
                if ([filterArray containsObject:fistPath]) {
                    continue;
                }
            }
            
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:targetPath error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                
            }else{
                
                NSLog(@"清除失败");
                
            }
        }
    }
}
// 缓存大小
+(CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}
@end
