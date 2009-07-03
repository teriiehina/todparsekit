//
//  PKParserFactory.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKToken;
@class PKTokenizer;
@class PKParser;
@class PKCollectionParser;

void PKReleaseSubparserTree(PKParser *p);

typedef enum {
    PKParserFactoryAssemblerSettingBehaviorOnAll        = 1 << 1, // Default
    PKParserFactoryAssemblerSettingBehaviorOnTerminals  = 1 << 2,
    PKParserFactoryAssemblerSettingBehaviorOnExplicit   = 1 << 3,
    PKParserFactoryAssemblerSettingBehaviorOnNone       = 1 << 4
} PKParserFactoryAssemblerSettingBehavior;

@interface PKParserFactory : NSObject {
    PKParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
    id assembler;
    NSMutableDictionary *parserTokensTable;
    NSMutableDictionary *parserClassTable;
    NSMutableDictionary *selectorTable;
    PKToken *equals;
    PKToken *curly;
    PKToken *paren;
    PKToken *gt;
    PKToken *bang;
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
    PKCollectionParser *differenceParser;
    PKCollectionParser *atomicValueParser;
    PKCollectionParser *negatedParserParser;
    PKCollectionParser *parserParser;
    PKCollectionParser *discardParser;
    PKCollectionParser *patternParser;
    PKCollectionParser *delimitedStringParser;
    PKParser *literalParser;
    PKParser *variableParser;
    PKParser *constantParser;
}
+ (id)factory;

- (PKParser *)parserFromGrammar:(NSString *)s assembler:(id)a;

@property (nonatomic) PKParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
@end
