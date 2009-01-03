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

enum {
    TDParserFactoryAssemblerSettingBehaviorOnAll        = 1 << 0,
    TDParserFactoryAssemblerSettingBehaviorOnTerminals  = 1 << 1,
    TDParserFactoryAssemblerSettingBehaviorOnExplicit   = 1 << 2
};
typedef NSUInteger TDParserFactoryAssemblerSettingBehavior;

@interface TDParserFactory : NSObject {
    TDParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
    id assembler;
    NSMutableDictionary *parserTokensTable;
    NSMutableDictionary *parserClassTable;
    NSMutableDictionary *selectorTable;
    TDToken *equals;
    TDToken *curly;
    BOOL isGatheringClasses;
    TDCollectionParser *statementParser;
    TDCollectionParser *declarationParser;
    TDCollectionParser *callbackParser;
    TDCollectionParser *selectorParser;
    TDCollectionParser *expressionParser;
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
    TDCollectionParser *atomicValueParser;
    TDCollectionParser *discardParser;
    TDParser *literalParser;
    TDParser *variableParser;
    TDParser *constantParser;
    TDParser *numParser;
}
+ (id)factory;

- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a;
- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a getTokenizer:(TDTokenizer **)t;

@property (nonatomic) TDParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
@end