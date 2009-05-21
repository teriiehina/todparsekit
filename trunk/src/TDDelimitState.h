//
//  TDDelimitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizerState.h>

@class TDSymbolRootNode;

@interface TDDelimitState : TDTokenizerState {
    TDSymbolRootNode *rootNode;
    BOOL balancesEOFTerminatedStrings;

    NSMutableArray *startSymbols;
    NSMutableArray *endSymbols;
    NSMutableArray *characterSets;
}

- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end allowedCharacterSet:(NSCharacterSet *)cs;
- (void)removeStartSymbol:(NSString *)start;

/*!
    @property   balancesEOFTerminatedStrings
    @brief      if true, this state will append a matching end delimiter symbol (<tt>'</tt> or <tt>"</tt>) to strings terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedStrings;
@end
