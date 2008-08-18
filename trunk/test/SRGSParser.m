//
//  SRGSParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "SRGSParser.h"

@interface SRGSParser ()
- (void)workOnWordAssembly:(TODAssembly *)a;
- (void)workOnNumAssembly:(TODAssembly *)a;
- (void)workOnQuotedStringAssembly:(TODAssembly *)a;
- (void)workOnStarAssembly:(TODAssembly *)a;
- (void)workOnQuestionAssembly:(TODAssembly *)a;
- (void)workOnAndAssembly:(TODAssembly *)a;
- (void)workOnOrAssembly:(TODAssembly *)a;
- (void)workOnAssignmentAssembly:(TODAssembly *)a;
- (void)workOnVariableAssembly:(TODAssembly *)a;
@end

@implementation SRGSParser

- (id)init {
	self = [super initWithSubparser:self.statementParser];
	if (self != nil) {
		//[self add:self.statementParser];
	}
	return self;
}


- (void)dealloc {
	self.statementParser = nil;
	self.exprOrAssignmentParser = nil;
	self.assignmentParser = nil;
	self.declarationParser = nil;
	self.variableParser = nil;
	self.expressionParser = nil;
	self.termParser = nil;
	self.orTermParser = nil;
	self.factorParser = nil;
	self.nextFactorParser = nil;
	self.phraseParser = nil;
	self.phraseStarParser = nil;
	self.phraseQuestionParser = nil;
	self.atomicValueParser = nil;
	[super dealloc];
}


- (id)parse:(NSString *)s {
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	a = [self completeMatchFor:a];
	return [a pop];
}


// statement		= exprOrAssignment ';'
// exprOrAssignment	= expression | assigment
// assigment		= declaration '=' expression
// declaration		= '$' Word
// variable			= '$' Word
// expression		= term orTerm*
// term				= factor nextFactor*
// orTerm			= '|' term
// factor			= phrase | phraseStar | phraseQuestion
// nextFactor		= factor
// phrase			= atomicValue | '(' expression ')'
// phraseStar		= phrase '*'
// phraseQuestion	= phrase '?'
// atomicValue		= Word | Num | QuotedString | variable

- (TODCollectionParser *)statementParser {
	if (!statementParser) {
		self.statementParser = [TODSequence sequence];
		[statementParser add:self.exprOrAssignmentParser];
		[statementParser add:[[TODSymbol symbolWithString:@";"] discard]];
	}
	return statementParser;
}


// exprOrAssignmentParser		= expression | assignment
- (TODCollectionParser *)exprOrAssignmentParser {
	if (!exprOrAssignmentParser) {
		self.exprOrAssignmentParser = [TODAlternation alternation];
		[exprOrAssignmentParser add:self.expressionParser];
		[exprOrAssignmentParser add:self.assignmentParser];
	}
	return exprOrAssignmentParser;
}


// declaration		= variable '=' expression
- (TODCollectionParser *)assignmentParser {
	if (!assignmentParser) {
		self.assignmentParser = [TODSequence sequence];
		[assignmentParser add:self.declarationParser];
		[assignmentParser add:[[TODSymbol symbolWithString:@"="] discard]];
		[assignmentParser add:self.expressionParser];
		[assignmentParser setAssembler:self selector:@selector(workOnAssignmentAssembly:)];
	}
	return assignmentParser;
}


// declaration			= '$' Word
- (TODCollectionParser *)declarationParser {
	if (!declarationParser) {
		self.declarationParser = [TODSequence sequence];
		[declarationParser add:[[TODSymbol symbolWithString:@"$"] discard]];
		[declarationParser add:[TODWord word]];
	}
	return declarationParser;
}


// variable			= '$' Word
- (TODCollectionParser *)variableParser {
	if (!variableParser) {
		self.variableParser = [TODSequence sequence];
		[variableParser add:[[TODSymbol symbolWithString:@"$"] discard]];
		[variableParser add:[TODWord word]];
	}
	return variableParser;
}


// expression		= term orTerm*
- (TODCollectionParser *)expressionParser {
	if (!expressionParser) {
		self.expressionParser = [TODSequence sequence];
		[expressionParser add:self.termParser];
		[expressionParser add:[TODRepetition repetitionWithSubparser:self.orTermParser]];
	}
	return expressionParser;
}


// term				= factor nextFactor*
- (TODCollectionParser *)termParser {
	if (!termParser) {
		self.termParser = [TODSequence sequence];
		[termParser add:self.factorParser];
		[termParser add:[TODRepetition repetitionWithSubparser:self.nextFactorParser]];
	}
	return termParser;
}


// orTerm			= '|' term
- (TODCollectionParser *)orTermParser {
	if (!orTermParser) {
		self.orTermParser = [TODSequence sequence];
		[orTermParser add:[[TODSymbol symbolWithString:@"|"] discard]];
		[orTermParser add:self.termParser];
		[orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
	}
	return orTermParser;
}


// factor			= phrase | phraseStar | phraseQuestion
- (TODCollectionParser *)factorParser {
	if (!factorParser) {
		self.factorParser = [TODAlternation alternation];
		[factorParser add:self.phraseParser];
		[factorParser add:self.phraseStarParser];
		[factorParser add:self.phraseQuestionParser];
	}
	return factorParser;
}


// nextFactor		= factor
- (TODCollectionParser *)nextFactorParser {
	if (!nextFactorParser) {
		self.nextFactorParser = [TODAlternation alternation];
		[nextFactorParser add:self.phraseParser];
		[nextFactorParser add:self.phraseStarParser];
		[nextFactorParser setAssembler:self selector:@selector(workOnAndAssembly:)];
	}
	return nextFactorParser;
}


// phrase			= atomicValue | '(' expression ')'
- (TODCollectionParser *)phraseParser {
	if (!phraseParser) {
		TODSequence *s = [TODSequence sequence];
		[s add:[[TODSymbol symbolWithString:@"("] discard]];
		[s add:self.expressionParser];
		[s add:[[TODSymbol symbolWithString:@")"] discard]];
		
		self.phraseParser = [TODAlternation alternation];
		[phraseParser add:self.atomicValueParser];
		[phraseParser add:s];
	}
	return phraseParser;
}


// phraseStar		= phrase '*'
- (TODCollectionParser *)phraseStarParser {
	if (!phraseStarParser) {
		self.phraseStarParser = [TODSequence sequence];
		[phraseStarParser add:self.phraseParser];
		[phraseStarParser add:[[TODSymbol symbolWithString:@"*"] discard]];
		[phraseStarParser setAssembler:self selector:@selector(workOnStarAssembly:)];
	}
	return phraseStarParser;
}


// phraseQuestion		= phrase '?'
- (TODCollectionParser *)phraseQuestionParser {
	if (!phraseQuestionParser) {
		self.phraseQuestionParser = [TODSequence sequence];
		[phraseQuestionParser add:self.phraseParser];
		[phraseQuestionParser add:[[TODSymbol symbolWithString:@"?"] discard]];
		[phraseQuestionParser setAssembler:self selector:@selector(workOnQuestionAssembly:)];
	}
	return phraseQuestionParser;
}


// atomicValue		= Word | Num | QuotedString | Variable
- (TODCollectionParser *)atomicValueParser {
	if (!atomicValueParser) {
		self.atomicValueParser = [TODAlternation alternation];
		
		TODParser *p = [TODWord word];
		[p setAssembler:self selector:@selector(workOnWordAssembly:)];
		[atomicValueParser add:p];

		p = [TODNum num];
		[p setAssembler:self selector:@selector(workOnNumAssembly:)];
		[atomicValueParser add:p];

		p = [TODQuotedString quotedString];
		[p setAssembler:self selector:@selector(workOnQuotedStringAssembly:)];
		[atomicValueParser add:p];

		p = self.variableParser;
		[p setAssembler:self selector:@selector(workOnVariableAssembly:)];
		[atomicValueParser add:p];
	}
	return atomicValueParser;
}


- (void)workOnWordAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	[a push:[TODLiteral literalWithString:tok.stringValue]];
}


- (void)workOnNumAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	[a push:[TODLiteral literalWithString:tok.stringValue]];
}


- (void)workOnQuotedStringAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	NSString *s = [tok.stringValue stringByRemovingFirstAndLastCharacters];
	
	TODSequence *p = [TODSequence sequence];
	TODTokenizer *t = [TODTokenizer tokenizerWithString:s];
	TODToken *eof = [TODToken EOFToken];
	while (eof != (tok = [t nextToken])) {
		[p add:[TODLiteral literalWithString:tok.stringValue]];
	}
	
	[a push:p];
}


- (void)workOnStarAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODRepetition *p = [TODRepetition repetitionWithSubparser:[a pop]];
	[a push:p];
}


- (void)workOnQuestionAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODAlternation *p = [TODAlternation alternation];
	[p add:[a pop]];
	[p add:[TODEmpty empty]];
	[a push:p];
}


- (void)workOnAndAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id top = [a pop];
	TODSequence *p = [TODSequence sequence];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}


- (void)workOnOrAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id top = [a pop];
//	NSLog(@"top: %@", top);
//	NSLog(@"top class: %@", [top class]);
	TODAlternation *p = [TODAlternation alternation];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}


- (void)workOnAssignmentAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id val = [a pop];
	TODToken *keyTok = [a pop];
	
	NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:a.target];
	[table setObject:val forKey:keyTok.stringValue];
	a.target = table;
}


- (void)workOnVariableAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *keyTok = [a pop];
	id val = [a.target objectForKey:keyTok.stringValue];
	
//	TODParser *p = nil;
//	if (valTok.isWord) {
//		p = [TODWord wordWithString:valTok.value];
//	} else if (valTok.isQuotedString) {
//		p = [TODQuotedString quotedStringWithString:valTok.value];
//	} else if (valTok.isNumber) {
//		p = [TODNum numWithString:valTok.stringValue];
//	}
	
	[a push:val];
}


@synthesize statementParser;
@synthesize exprOrAssignmentParser;
@synthesize assignmentParser;
@synthesize declarationParser;
@synthesize variableParser;
@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize phraseQuestionParser;
@synthesize atomicValueParser;
@end