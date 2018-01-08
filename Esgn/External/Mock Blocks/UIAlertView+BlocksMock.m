//
//  UIAlertView+BlocksMock.m
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import "UIAlertView+BlocksMock.h"
#import "UIAlertView+BlocksKit.h"

@implementation UIAlertView (BlocksMock)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block{
    return [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:block];
}


+ (id)alertViewWithTitle:(NSString *)title{
    return [UIAlertView bk_alertViewWithTitle:title];
}

+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    return [UIAlertView bk_alertViewWithTitle:title message:message];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message{
    return [self bk_initWithTitle:title message:message];
}

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block{
    return [self bk_addButtonWithTitle:title handler:block];
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

- (void)alignAlertView:(NSTextAlignment)alignment {
    NSArray *subViewArray = self.subviews;
    for(int x = 0; x < [subViewArray count]; x++){
        
        //If the current subview is a UILabel...
        if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            UILabel *label = [subViewArray objectAtIndex:x];
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
}
@end
