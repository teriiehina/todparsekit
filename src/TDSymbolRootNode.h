//
//  TDSymbolRootNode.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDSymbolNode.h>

@class TDReader;

/*!
	@class       TDSymbolRootNode 
	@superclass  TDSymbolNode
	@brief		 This class is a special case of a <tt>TDSymbolNode</tt>.
	@details	 This class is a special case of a <tt>TDSymbolNode</tt>. A <tt>TDSymbolRootNode</tt> object has no symbol of its own, but has children that represent all possible symbols.
*/
@interface TDSymbolRootNode : TDSymbolNode {
}

/*!
	@fn			add:
	@brief		Adds the given string as a multi-character symbol.
	@param      s a multi-character symbol that should be recognized as a single symbol token by this state
*/
- (void)add:(NSString *)s;

/*!
	@fn			nextSymbol:startingWith:
	@brief		Return a symbol string from a reader.
	@param      r the reader from which to read
	@param      cin the character from witch to start
	@result     a symbol string from a reader
*/
- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin;
@end
