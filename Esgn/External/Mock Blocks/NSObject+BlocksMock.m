//
//  NSObject+BlocksMock.m
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import "NSObject+BlocksMock.h"
#import "NSObject+BKBlockExecution.h"
@implementation NSObject (BlocksMock)
- (id)performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay{
    return [self bk_performBlock:block afterDelay:delay];
}
+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{
    return [self bk_performBlock:block afterDelay:delay];
}
+ (void)cancelBlock:(id)block{
    [self bk_cancelBlock:block];
}
@end
