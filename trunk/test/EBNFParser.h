//
//  EBNFParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface EBNFParser : TDRepetition {
    TDTokenizer *tokenizer;
    TDCollectionParser *statementParser;
    TDCollectionParser *exprOrAssignmentParser;
    TDCollectionParser *assignmentParser;
    TDCollectionParser *declarationParser;
    TDCollectionParser *variableParser;
    TDCollectionParser *expressionParser;
    TDCollectionParser *termParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *factorParser;
    TDCollectionParser *nextFactorParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *phraseStarParser;
    TDCollectionParser *phraseQuestionParser;
    TDCollectionParser *phrasePlusParser;
    TDCollectionParser *atomicValueParser;
}
- (id)parse:(NSString *)s;

@property (retain, readonly) TDTokenizer *tokenizer;
@property (retain) TDCollectionParser *statementParser;
@property (retain) TDCollectionParser *exprOrAssignmentParser;
@property (retain) TDCollectionParser *assignmentParser;
@property (retain) TDCollectionParser *declarationParser;
@property (retain) TDCollectionParser *variableParser;
@property (retain) TDCollectionParser *expressionParser;
@property (retain) TDCollectionParser *termParser;
@property (retain) TDCollectionParser *orTermParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *nextFactorParser;
@property (retain) TDCollectionParser *phraseParser;
@property (retain) TDCollectionParser *phraseStarParser;
@property (retain) TDCollectionParser *phraseQuestionParser;
@property (retain) TDCollectionParser *phrasePlusParser;
@property (retain) TDCollectionParser *atomicValueParser;
@end
