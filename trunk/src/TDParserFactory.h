//
//  TDParserFactory.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizer;
@class TDParser;
@class TDCollectionParser;

void TDReleaseSubparserTree(TDParser *p);

typedef enum {
    TDParserFactoryAssemblerSettingBehaviorOnNone       = 0,
    TDParserFactoryAssemblerSettingBehaviorOnAll        = 1 << 1, // Default
    TDParserFactoryAssemblerSettingBehaviorOnTerminals  = 1 << 2,
    TDParserFactoryAssemblerSettingBehaviorOnExplicit   = 1 << 3
} TDParserFactoryAssemblerSettingBehavior;

@interface TDParserFactory : NSObject {
    TDParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
    id assembler;
    NSMutableDictionary *parserTokensTable;
    NSMutableDictionary *parserClassTable;
    NSMutableDictionary *selectorTable;
    TDToken *equals;
    TDToken *curly;
    TDToken *paren;
    TDToken *caret;
    BOOL isGatheringClasses;
    TDCollectionParser *statementParser;
    TDCollectionParser *declarationParser;
    TDCollectionParser *callbackParser;
    TDCollectionParser *selectorParser;
    TDCollectionParser *exprParser;
    TDCollectionParser *termParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *factorParser;
    TDCollectionParser *nextFactorParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *phraseStarParser;
    TDCollectionParser *phrasePlusParser;
    TDCollectionParser *phraseQuestionParser;
    TDCollectionParser *phraseCardinalityParser;
    TDCollectionParser *cardinalityParser;
    TDCollectionParser *primaryExprParser;
    TDCollectionParser *predicateParser;
    TDCollectionParser *intersectionParser;
    TDCollectionParser *exclusionParser;
    TDCollectionParser *atomicValueParser;
    TDCollectionParser *discardParser;
    TDCollectionParser *patternParser;
    TDCollectionParser *delimitedStringParser;
    TDParser *literalParser;
    TDParser *variableParser;
    TDParser *constantParser;
}
+ (id)factory;

- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a;

@property (nonatomic) TDParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
@end
