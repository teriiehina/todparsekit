//
//  TDWordOrReservedState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDWordState.h>

/*!
	@class       TDWordOrReservedState 
	@superclass  TDWordState
	@abstract    Override <tt>TDWordState</tt> to return known reserved words as tokens of type <tt>TDTT_RESERVED</tt>.
	@discussion  Override <tt>TDWordState</tt> to return known reserved words as tokens of type <tt>TDTT_RESERVED</tt>.
*/
@interface TDWordOrReservedState : TDWordState {
	NSMutableSet *reservedWords;
}

/*!
	@fn			addReservedWord:
	@abstract   Adds the specified string as a known reserved word.
	@param      s reserved word to add
*/
- (void)addReservedWord:(NSString *)s;
@end
