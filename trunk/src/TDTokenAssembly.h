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
    @superclass  TDAssembly <NSCopying>
    @abstract    A TokenAssembly is an Assembly whose elements are Tokens.
    @discussion  A TokenAssembly is an Assembly whose elements are Tokens. Tokens are, roughly, the chunks of text that a <tt>TDTokenizer</tt> returns.
*/
@interface TDTokenAssembly : TDAssembly <NSCopying> {
	TDTokenizer *tokenizer;
	NSMutableArray *tokens;
}

/*!
    @method     
    @abstract   The tokenizer that provides the stream of tokens for this assembly.
*/
@property (nonatomic, retain) TDTokenizer *tokenizer;
@end
