//
//  TDSlashSlashState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

/*!
	@class       TDSlashSlashState 
	@superclass  TDTokenizerState
	@abstract    A <tt>TDSlashSlashState</tt> ignores everything up to an end-of-line and returns the tokenizer's next token.
	@discussion  A <tt>TDSlashSlashState</tt> ignores everything up to an end-of-line and returns the tokenizer's next token.
*/
@interface TDSlashSlashState : TDTokenizerState {
	
}

@end
