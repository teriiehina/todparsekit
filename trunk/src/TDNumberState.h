//
//  TDNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

/*!
	@class       TDNumberState 
	@superclass  TDTokenizerState
	@abstract    A <tt>TDNumberState</tt> object returns a number from a reader.
	@discussion  A <tt>TDNumberState</tt> object returns a number from a reader. This state's idea of a number allows an optional, initial minus sign, followed by one or more digits. A decimal point and another string of digits may follow these digits.
*/
@interface TDNumberState : TDTokenizerState {
	BOOL allowsTrailingDot;
	BOOL gotADigit;
	BOOL negative;
	NSInteger c;
	CGFloat floatValue;
}

/*!
	@method     allowsTrailingDot
	@abstract   If true, numbers are allowed to end with a trialing dot, e.g. <tt>42.<tt>
	@discussion false by default.
*/
@property (nonatomic) BOOL allowsTrailingDot;
@end
