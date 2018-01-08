//
//  UITapGestureRecognizer+BlocksMock.m
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import "UITapGestureRecognizer+BlocksMock.h"
#import "UIGestureRecognizer+BlocksKit.h"
@implementation UIGestureRecognizer (BlocksMock)
+ (id)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay{
    return [UIGestureRecognizer bk_recognizerWithHandler:block delay:delay];
}
- (id)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay{
    return [self bk_initWithHandler:block delay:delay];
}


+ (id)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block{
    return [UIGestureRecognizer bk_recognizerWithHandler:block];
}
- (id)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block{
    return [self bk_initWithHandler:block];
}

- (void)cancel{
    [self bk_cancel];
}

@end
