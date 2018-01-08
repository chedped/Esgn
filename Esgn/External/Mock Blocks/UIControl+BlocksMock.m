//
//  UIControl+BlocksMock.m
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import "UIControl+BlocksMock.h"
#import "UIControl+BlocksKit.h"
@implementation UIControl (BlocksMock)
- (void)addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents{
    [self  bk_addEventHandler:handler forControlEvents:controlEvents];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents{
    [self bk_removeEventHandlersForControlEvents:controlEvents];
}

- (BOOL)hasEventHandlersForControlEvents:(UIControlEvents)controlEvents{
    return [self bk_hasEventHandlersForControlEvents:controlEvents];
}
@end
