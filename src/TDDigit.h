//
//  TDDigit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTerminal.h>

/*!
	@class       TDDigit 
	@superclass  TDTerminal
	@abstract    A <tt>TDDigit</tt> matches a digit from a character assembly.
	@discussion  A <tt>TDDigit</tt> matches a digit from a character assembly. <tt>-[TDDitgit qualifies:] returns true if an assembly's next element is a digit.
*/
@interface TDDigit : TDTerminal {

}

/*!
	@method     digit
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDDigit</tt> parser.
	@result     an initialized autoreleased <tt>TDDigit</tt> parser.
*/
+ (id)digit;
@end
