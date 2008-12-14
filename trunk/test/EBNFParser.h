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

@property (nonatomic, retain, readonly) TDTokenizer *tokenizer;
@property (nonatomic, retain) TDCollectionParser *statementParser;
@property (nonatomic, retain) TDCollectionParser *exprOrAssignmentParser;
@property (nonatomic, retain) TDCollectionParser *assignmentParser;
@property (nonatomic, retain) TDCollectionParser *declarationParser;
@property (nonatomic, retain) TDCollectionParser *variableParser;
@property (nonatomic, retain) TDCollectionParser *expressionParser;
@property (nonatomic, retain) TDCollectionParser *termParser;
@property (nonatomic, retain) TDCollectionParser *orTermParser;
@property (nonatomic, retain) TDCollectionParser *factorParser;
@property (nonatomic, retain) TDCollectionParser *nextFactorParser;
@property (nonatomic, retain) TDCollectionParser *phraseParser;
@property (nonatomic, retain) TDCollectionParser *phraseStarParser;
@property (nonatomic, retain) TDCollectionParser *phraseQuestionParser;
@property (nonatomic, retain) TDCollectionParser *phrasePlusParser;
@property (nonatomic, retain) TDCollectionParser *atomicValueParser;
@end
