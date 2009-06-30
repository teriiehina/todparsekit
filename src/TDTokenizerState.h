//
//  TDParseKitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKTypes.h>

@class TDToken;
@class TDTokenizer;
@class PKReader;

/*!
    @class      TDTokenizerState 
    @brief      A <tt>TDTokenizerState</tt> returns a token, given a reader, an initial character read from the reader, and a tokenizer that is conducting an overall tokenization of the reader.
    @details    The tokenizer will typically have a character state table that decides which state to use, depending on an initial character. If a single character is insufficient, a state such as <tt>TDSlashState</tt> will read a second character, and may delegate to another state, such as <tt>TDSlashStarState</tt>. This prospect of delegation is the reason that the <tt>-nextToken</tt> method has a tokenizer argument.
*/
@interface TDTokenizerState : NSObject {
    NSMutableString *stringbuf;
    NSUInteger offset;
    TDTokenizerState *fallbackState;
}

/*!
    @brief      Return a token that represents a logical piece of a reader.
    @param      r the reader from which to read additional characters
    @param      cin the character that a tokenizer used to determine to use this state
    @param      t the tokenizer currently powering the tokenization
    @result     a token that represents a logical piece of the reader
*/
- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t;

/*!
    @property   fallbackState
    @brief      The state this tokenizer defers to if it starts, but ultimately aborts recognizing a token
*/
@property (nonatomic, retain) TDTokenizerState *fallbackState;
@end
