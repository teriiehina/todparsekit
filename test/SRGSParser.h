//
//  SRGSParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODParseKit.h>

@interface SRGSParser : TODRepetition {
	TODCollectionParser *statementParser;
	TODCollectionParser *exprOrAssignmentParser;
	TODCollectionParser *assignmentParser;
	TODCollectionParser *declarationParser;
	TODCollectionParser *variableParser;
	TODCollectionParser *expressionParser;
	TODCollectionParser *termParser;
	TODCollectionParser *orTermParser;
	TODCollectionParser *factorParser;
	TODCollectionParser *nextFactorParser;
	TODCollectionParser *phraseParser;
	TODCollectionParser *phraseStarParser;
	TODCollectionParser *phraseQuestionParser;
	TODCollectionParser *atomicValueParser;
}
- (id)parse:(NSString *)s;

@property (retain) TODCollectionParser *statementParser;
@property (retain) TODCollectionParser *exprOrAssignmentParser;
@property (retain) TODCollectionParser *assignmentParser;
@property (retain) TODCollectionParser *declarationParser;
@property (retain) TODCollectionParser *variableParser;
@property (retain) TODCollectionParser *expressionParser;
@property (retain) TODCollectionParser *termParser;
@property (retain) TODCollectionParser *orTermParser;
@property (retain) TODCollectionParser *factorParser;
@property (retain) TODCollectionParser *nextFactorParser;
@property (retain) TODCollectionParser *phraseParser;
@property (retain) TODCollectionParser *phraseStarParser;
@property (retain) TODCollectionParser *phraseQuestionParser;
@property (retain) TODCollectionParser *atomicValueParser;
@end
