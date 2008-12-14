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
    TDCollectionParser *expressionParser;
    TDCollectionParser *termParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *factorParser;
    TDCollectionParser *nextFactorParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *phraseStarParser;
    TDCollectionParser *phrasePlusParser;
    TDCollectionParser *phraseQuestionParser;
    TDCollectionParser *letterOrDigitParser;
}
+ (id)parserForLanguage:(NSString *)s;

@property (retain) TDCollectionParser *expressionParser;
@property (retain) TDCollectionParser *termParser;
@property (retain) TDCollectionParser *orTermParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *nextFactorParser;
@property (retain) TDCollectionParser *phraseParser;
@property (retain) TDCollectionParser *phraseStarParser;
@property (retain) TDCollectionParser *phrasePlusParser;
@property (retain) TDCollectionParser *phraseQuestionParser;
@property (retain) TDCollectionParser *letterOrDigitParser;
@end
