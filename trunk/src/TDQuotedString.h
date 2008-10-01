//
//  TDQuotedString.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

/*!
	@class       TDQuotedString 
	@superclass  TDTerminal
	@abstract    A <tt>TDQuotedString</tt> matches a quoted string, like "this one" from a token assembly.
	@discussion  A <tt>TDQuotedString</tt> matches a quoted string, like "this one" from a token assembly.
*/
@interface TDQuotedString : TDTerminal {

}

/*!
	@fn			quotedString
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDQuotedString</tt> object.
	@result     an initialized autoreleased <tt>TDQuotedString</tt> object
*/
+ (id)quotedString;
@end
