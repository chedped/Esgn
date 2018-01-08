//
//  UIActionSheet+BlocksMock.h
//  myLife
//
//  Created by Nitigron Ruengmontre on 4/1/57 BE.
//  Copyright (c) 2557 Appsynth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (BlocksMock)
+ (id)actionSheetWithTitle:(NSString *)title;

/** Returns a configured action sheet with only a title and cancel button.
 
 @param title The header of the action sheet.
 @return An instantiated actionSheet.
 */
- (id)initWithTitle:(NSString *)title;

///-----------------------------------
/// @name Adding buttons
///-----------------------------------

/** Add a new button with an associated code block.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

/** Set the destructive (red) button with an associated code block.
 
 @warning Because buttons cannot be removed from an action sheet,
 be aware that the effects of calling this method are cumulative.
 Previously added destructive buttons will become normal buttons.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (NSInteger)setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

/** Set the title and trigger of the cancel button.
 
 `block` can be set to `nil`, but this is generally useless as
 the cancel button is configured already to do nothing.
 
 iPhone users will have the button shown regardless; if the title is
 set to `nil`, it will automatically be localized.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

///-----------------------------------
/// @name Altering actions
///-----------------------------------

/** Sets the block that is to be fired when a button is pressed.
 
 @param block A code block, or nil to set no response.
 @param index The index of a button already added to the action sheet.
 */
- (void)setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index;

/** The block that is to be fired when a button is pressed.
 
 @param index The index of a button already added to the action sheet.
 @return A code block, or nil if no block is assigned.
 */
- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index;
@end
