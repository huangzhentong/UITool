//
//  PublicCache.h
//  OperationalSystem
//
//  Created by KT--stc08 on 2019/3/26.
//  Copyright © 2019 KT--stc08. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicCache : NSObject
//清楚缓存
+(void)removeCache:(NSArray*)filterArray;
//计算缓存大小
+(CGFloat)folderSize;
@end

NS_ASSUME_NONNULL_END
