//
//  TDSymbol.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

@class TDToken;

/*!
	@class       TDSymbol 
	@superclass  TDTerminal
	@brief		 A <tt>TDSymbol</tt> matches a specific sequence, such as <tt>&lt;</tt>, or <tt>&lt;=</tt> that a tokenizer returns as a symbol.
	@details	 A <tt>TDSymbol</tt> matches a specific sequence, such as <tt>&lt;</tt>, or <tt>&lt;=</tt> that a tokenizer returns as a symbol.
*/
@interface TDSymbol : TDTerminal {
	TDToken *symbol;
}

/*!
	@fn			symbol
	@brief		Convenience factory method for initializing an autoreleased <tt>TDSymbol</tt> object with a <tt>nil</tt> string value.
	@result     an initialized autoreleased <tt>TDSymbol</tt> object with a <tt>nil</tt> string value
*/
+ (id)symbol;

/*!
	@fn			symbolWithString:
	@brief		Convenience factory method for initializing an autoreleased <tt>TDSymbol</tt> object with <tt>s</tt> as a string value.
	@param		s the string represented by this symbol
	@result     an initialized autoreleased <tt>TDSymbol</tt> object with <tt>s</tt> as a string value
*/
+ (id)symbolWithString:(NSString *)s;
@end
