//
//  TDGrammarParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDGrammarParser : TDSequence {
    TDTokenizer *tokenizer;
    TDCollectionParser *statementParser;
    TDCollectionParser *declarationParser;
    TDCollectionParser *expressionParser;
    TDCollectionParser *termParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *factorParser;
    TDCollectionParser *nextFactorParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *phraseStarParser;
    TDCollectionParser *phrasePlusParser;
    TDCollectionParser *phraseQuestionParser;
    TDCollectionParser *atomicValueParser;
    TDParser *literalParser;
    TDParser *variableParser;
    TDParser *constantParser;
    TDParser *numParser;
}
+ (TDCollectionParser *)parserForLanguage:(NSString *)s;
+ (TDCollectionParser *)parserForExpression:(NSString *)s;

@property (retain) TDTokenizer *tokenizer;
@property (retain) TDCollectionParser *statementParser;
@property (retain) TDCollectionParser *declarationParser;
@property (retain) TDCollectionParser *expressionParser;
@property (retain) TDCollectionParser *termParser;
@property (retain) TDCollectionParser *orTermParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *nextFactorParser;
@property (retain) TDCollectionParser *phraseParser;
@property (retain) TDCollectionParser *phraseStarParser;
@property (retain) TDCollectionParser *phrasePlusParser;
@property (retain) TDCollectionParser *phraseQuestionParser;
@property (retain) TDCollectionParser *atomicValueParser;
@property (retain) TDParser *literalParser;
@property (retain) TDParser *variableParser;
@property (retain) TDParser *constantParser;
@property (retain) TDParser *numParser;
@end
