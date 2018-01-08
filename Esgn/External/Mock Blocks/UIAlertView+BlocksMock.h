//
//  UIAlertView+BlocksMock.h
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (BlocksMock)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

+ (id)alertViewWithTitle:(NSString *)title;

+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (void)setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index;

- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index;

- (void)alignAlertView:(NSTextAlignment)alignment;
@end
