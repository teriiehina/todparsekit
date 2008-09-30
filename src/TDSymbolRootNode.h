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
    @abstract    This class is a special case of a <tt>TDSymbolNode</tt>.
	@discussion  This class is a special case of a <tt>TDSymbolNode</tt>. A <tt>TDSymbolRootNode</tt> object has no symbol of its own, but has children that represent all possible symbols.
*/
@interface TDSymbolRootNode : TDSymbolNode {
}
- (void)add:(NSString *)s;
- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin;
@end
