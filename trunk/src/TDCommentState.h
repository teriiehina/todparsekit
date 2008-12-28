//
//  TDCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@class TDSingleLineCommentState;
@class TDMultiLineCommentState;

/*!
    @class      TDCommentState
    @brief      This state will either delegate to a comment-handling state, or return a <tt>TDSymbol</tt> token with just the first char in it.
    @details    By default, C and C++ style comments. (<tt>//</tt> to end of line and <tt>/* *\/</tt>)
*/
@interface TDCommentState : TDTokenizerState {
    TDSingleLineCommentState *singleLineState;
    TDMultiLineCommentState *multiLineState;
    BOOL reportsCommentTokens;
    BOOL balancesEOFTerminatedComments;
}

- (void)addSingleLineStartToken:(TDToken *)startTok;


- (void)addMultiLineStartToken:(TDToken *)startTok endToken:(TDToken *)endTok;

/*!
    @property   reportsCommentTokens
    @brief      if true, return comment tokens, otherwise silently consume comments
    @details    if true, this state will return <tt>TDToken</tt>s of type <tt>TDTokenTypeComment</tt>.
                Otherwise, it will silently consume comment text and return the next token from another of the tokenizer's states
*/
@property (nonatomic) BOOL reportsCommentTokens;

/*!
    @property   balancesEOFTerminatedComments
    @brief      if true, this state will append a matching comment string (<tt>*\/</tt> [C++] or <tt>:)</tt> [XQuery]) to quotes terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedComments;
@end
