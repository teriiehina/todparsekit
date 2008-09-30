//
//  TDSlashStarState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

/*!
    @class       TDSlashStarState 
    @superclass  TDTokenizerState
    @abstract    A <tt>TDSlashStarState</tt> ignores everything up to a closing star and slash, and then returns the tokenizer's next token.
    @discussion  A <tt>TDSlashStarState</tt> ignores everything up to a closing star and slash, and then returns the tokenizer's next token.
*/
@interface TDSlashStarState : TDTokenizerState {
	
}

@end
