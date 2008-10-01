//
//  TDTokenAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAssembly.h>

@class TDTokenizer;

/*!
	@class       TDTokenAssembly 
	@superclass  TDAssembly
	@abstract    A <tt>TDTokenAssembly</tt> is a <tt>TDAssembly</tt> whose elements are <tt>TDTokens</tt>.
	@discussion  A <tt>TDTokenAssembly</tt> is a <tt>TDAssembly</tt> whose elements are <tt>TDTokens</tt>. <tt>TDTokens</tt> are, roughly, the chunks of text that a <tt>TDTokenizer</tt> returns.
*/
@interface TDTokenAssembly : TDAssembly <NSCopying> {
	TDTokenizer *tokenizer;
	NSMutableArray *tokens;
}

/*!
	@fn			
	@abstract   The tokenizer that provides the stream of tokens for this assembly.
*/
@property (nonatomic, retain) TDTokenizer *tokenizer;
@end
