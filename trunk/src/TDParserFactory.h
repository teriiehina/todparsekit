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
@class PKParser;
@class PKCollectionParser;

void TDReleaseSubparserTree(PKParser *p);

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
    PKCollectionParser *statementParser;
    PKCollectionParser *declarationParser;
    PKCollectionParser *callbackParser;
    PKCollectionParser *selectorParser;
    PKCollectionParser *exprParser;
    PKCollectionParser *termParser;
    PKCollectionParser *orTermParser;
    PKCollectionParser *factorParser;
    PKCollectionParser *nextFactorParser;
    PKCollectionParser *phraseParser;
    PKCollectionParser *phraseStarParser;
    PKCollectionParser *phrasePlusParser;
    PKCollectionParser *phraseQuestionParser;
    PKCollectionParser *phraseCardinalityParser;
    PKCollectionParser *cardinalityParser;
    PKCollectionParser *primaryExprParser;
    PKCollectionParser *predicateParser;
    PKCollectionParser *intersectionParser;
    PKCollectionParser *exclusionParser;
    PKCollectionParser *atomicValueParser;
    PKCollectionParser *discardParser;
    PKCollectionParser *patternParser;
    PKCollectionParser *delimitedStringParser;
    PKParser *literalParser;
    PKParser *variableParser;
    PKParser *constantParser;
}
+ (id)factory;

- (PKParser *)parserFromGrammar:(NSString *)s assembler:(id)a;

@property (nonatomic) TDParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
@end
