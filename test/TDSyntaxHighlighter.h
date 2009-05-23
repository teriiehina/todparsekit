//
//  TDSyntaxHighlighter.h
//  HTTPClient
//
//  Created by Todd Ditchendorf on 12/26/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDParser;
@class TDTokenizer;
@class TDParserFactory;
@class TDMiniCSSAssembler;
@class TDGenericAssembler;

@interface TDSyntaxHighlighter : NSObject {
    TDParserFactory *parserFactory;
    TDParser *miniCSSParser;
    TDMiniCSSAssembler *miniCSSAssembler;
    TDGenericAssembler *genericAssembler;
    BOOL cacheParsers;
    NSMutableDictionary *parserCache;
    NSMutableDictionary *tokenizerCache;
}
- (NSAttributedString *)highlightedStringForString:(NSString *)s ofGrammar:(NSString *)grammarName;

@property (nonatomic) BOOL cacheParsers; // default is NO
@end