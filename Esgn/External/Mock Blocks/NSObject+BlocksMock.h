//
//  NSObject+BlocksMock.h
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BlocksMock)
- (id)performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay;

/** Executes a block after a given delay.
 
 This class method is functionally identical to its instance method version.  It still executes
 asynchronously via GCD.  However, the current context is not passed so that the block is performed
 in a general context.
 
 Block execution is very useful, particularly for small events that you would like delayed.
 
 [object performBlock:^{
 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
 } afterDelay:0.5f];
 
 @see performBlock:afterDelay:
 @param block A code block.
 @param delay A measure in seconds.
 @return Returns a pointer to the block that may or may not execute the given block.
 */
+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

/** Cancels the potential execution of a block.
 
 @warning *Important:* It is not recommended to cancel a block executed
 with no delay (a delay of 0.0).  While it it still possible to catch the block
 before GCD has executed it, it has likely already been executed and disposed of.
 
 @param block A pointer to a containing block, as returned from one of the
 `performBlock` selectors.
 */
+ (void)cancelBlock:(id)block;
@end
