//
//  UITapGestureRecognizer+BlocksMock.h
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (BlocksMock)
+ (id)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;

/** Initializes an allocated gesture recognizer that will call the given block
 after a given delay.
 
 An alternative to the designated initializer.
 
 @return An initialized instance of a concrete UIGestureRecognizer subclass or `nil`.
 @param block The block which handles an executed gesture.
 @param delay A number of seconds after which the block will fire.
 */
- (id)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay NS_REPLACES_RECEIVER;

/** An autoreleased gesture recognizer that will call the given block.
 
 For convenience and compatibility reasons, this method is indentical
 to using recognizerWithHandler:delay: with a delay of 0.0.
 
 @return An initialized and autoreleased instance of a concrete UIGestureRecognizer
 subclass, or `nil`.
 @param block The block which handles an executed gesture.
 */
+ (id)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;

/** Initializes an allocated gesture recognizer that will call the given block.
 
 This method is indentical to calling initWithHandler:delay: with a delay of 0.0.
 
 @return An initialized instance of a concrete UIGestureRecognizer subclass or `nil`.
 @param block The block which handles an executed gesture.
 */
- (id)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;


- (void)cancel;
@end
