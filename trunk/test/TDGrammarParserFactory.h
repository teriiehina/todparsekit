//
//  TDGrammarParserFactory.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDGrammarParserFactory : NSObject {
    TDTokenizer *tokenizer;
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
    TDParser *literalParser;
    TDParser *variableParser;
    TDParser *constantParser;
    TDParser *numParser;
}
+ (id)factory;

- (TDParser *)parserForGrammar:(NSString *)s assembler:(id)a;
@end
