//
//  UIActionSheet+BlocksMock.m
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import "UIActionSheet+BlocksMock.h"
#import "UIActionSheet+BlocksKit.h"

@implementation UIActionSheet (BlocksMock)
+ (id)actionSheetWithTitle:(NSString *)title{
    return [UIActionSheet bk_actionSheetWithTitle:title];
}
- (id)initWithTitle:(NSString *)title{
    return [self bk_initWithTitle:title];
}
- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block{
    return [self bk_addButtonWithTitle:title handler:block];
}
- (NSInteger)setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block{
    return [self bk_setDestructiveButtonWithTitle:title handler:block];
}
- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block{
    return [self bk_setCancelButtonWithTitle:title handler:block];
}
- (void)setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index{
    [self bk_setHandler:block forButtonAtIndex:index];
}
- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index{
    return [self bk_handlerForButtonAtIndex:index];
}
@end
