//
//  TDDelimitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizerState.h>

@class TDSymbolRootNode;

/*!
    @class      TDDelimitState 
    @brief      A delimit state returns a delimited string token from a reader
    @details    This state will collect characters until it sees a match to the end symbol that corresponds to the start symbol the tokenizer used to switch to this state.
*/
@interface TDDelimitState : TDTokenizerState {
    TDSymbolRootNode *rootNode;
    BOOL balancesEOFTerminatedStrings;

    NSMutableArray *startSymbols;
    NSMutableArray *endSymbols;
    NSMutableArray *characterSets;
}

/*!
    @brief      Adds the given strings as a delimited string start and end markers. both may be multi-char
    @details    <tt>start</tt> and <tt>end</tt> may be different strings. e.g. <tt>&lt;#</tt> and <tt>#&gt;</tt>.
    @param      start a single- or multi-character symbol that should be recognized as the start of a multi-line comment
    @param      end a single- or multi-character symbol that should be recognized as the end of a multi-line comment that began with <tt>start</tt>
*/
- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end allowedCharacterSet:(NSCharacterSet *)cs;

/*!
    @brief      Removes <tt>start</tt> and its orignal <tt>end</tt> counterpart as a delimited string start and end markers.
    @details    If <tt>start</tt> was never added as a delimited string start symbol, this has no effect.
    @param      start a single- or multi-character symbol that should no longer be recognized as the start of a delimited string
*/
- (void)removeStartSymbol:(NSString *)start;

/*!
    @property   balancesEOFTerminatedStrings
    @brief      if true, this state will append a matching end delimiter symbol (<tt>'</tt> or <tt>"</tt>) to strings terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedStrings;
@end
