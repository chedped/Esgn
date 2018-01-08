//
//  UIControl+BlocksMock.h
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BlocksMock)
- (void)addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

- (BOOL)hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;
@end
