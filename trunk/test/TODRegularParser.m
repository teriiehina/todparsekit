//
//  TODRegularParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODRegularParser.h"

@interface TODRegularParser ()
- (void)workOnCharAssembly:(TODAssembly *)a;
- (void)workOnStarAssembly:(TODAssembly *)a;
- (void)workOnAndAssembly:(TODAssembly *)a;
- (void)workOnOrAssembly:(TODAssembly *)a;
@end

@implementation TODRegularParser

- (id)init {
	self = [super init];
	if (self != nil) {
		[self add:self.expressionParser];
	}
	return self;
}


- (void)dealloc {
	self.expressionParser = nil;
	self.termParser = nil;
	self.orTermParser = nil;
	self.factorParser = nil;
	self.nextFactorParser = nil;
	self.phraseParser = nil;
	self.phraseStarParser = nil;
	self.letterOrDigitParser = nil;
	[super dealloc];
}


- (id)parse:(NSString *)s {
	TODAssembly *a = [TODCharacterAssembly assemblyWithString:s];
	a = [self completeMatchFor:a];
	return [a pop];
}


// expression		= term orTerm*
// term				= factor nextFactor*
// orTerm			= '|' term
// factor			= phrase | phraseStar
// nextFactor		= factor
// phrase			= letterOrDigit | '(' expression ')'
// phraseStar		= phrase '*'
// letterOrDigit	= Letter | Digit


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
		[orTermParser add:[[TODSpecificChar specificCharWithChar:'|'] discard]];
		[orTermParser add:self.termParser];
		[orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
	}
	return orTermParser;
}


// factor			= phrase | phraseStar
- (TODCollectionParser *)factorParser {
	if (!factorParser) {
		self.factorParser = [TODAlternation alternation];
		[factorParser add:self.phraseParser];
		[factorParser add:self.phraseStarParser];
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


// phrase			= letterOrDigit | '(' expression ')'
- (TODCollectionParser *)phraseParser {
	if (!phraseParser) {
		TODSequence *s = [TODSequence sequence];
		[s add:[[TODSpecificChar specificCharWithChar:'('] discard]];
		[s add:self.expressionParser];
		[s add:[[TODSpecificChar specificCharWithChar:')'] discard]];

		self.phraseParser = [TODAlternation alternation];
		[phraseParser add:self.letterOrDigitParser];
		[phraseParser add:s];
	}
	return phraseParser;
}


// phraseStar		= phrase '*'
- (TODCollectionParser *)phraseStarParser {
	if (!phraseStarParser) {
		self.phraseStarParser = [TODSequence sequence];
		[phraseStarParser add:self.phraseParser];
		[phraseStarParser add:[[TODSpecificChar specificCharWithChar:'*'] discard]];
		[phraseStarParser setAssembler:self selector:@selector(workOnStarAssembly:)];
	}
	return phraseStarParser;
}


// letterOrDigit	= Letter | Digit
- (TODCollectionParser *)letterOrDigitParser {
	if (!letterOrDigitParser) {
		self.letterOrDigitParser = [TODAlternation alternation];
		[letterOrDigitParser add:[TODLetter letter]];
		[letterOrDigitParser add:[TODDigit digit]];
		[letterOrDigitParser setAssembler:self selector:@selector(workOnCharAssembly:)];
	}
	return letterOrDigitParser;
}


- (void)workOnCharAssembly:(TODAssembly *)a {
	NSLog(@"%s", _cmd);
	NSLog(@"a: %@", a);
	id obj = [a pop];
	NSInteger c = [obj integerValue];
	[a push:[TODSpecificChar specificCharWithChar:c]];
}


- (void)workOnStarAssembly:(TODAssembly *)a {
	NSLog(@"%s", _cmd);
	NSLog(@"a: %@", a);
	TODRepetition *p = [TODRepetition repetitionWithSubparser:[a pop]];
	[a push:p];
}


- (void)workOnAndAssembly:(TODAssembly *)a {
	NSLog(@"%s", _cmd);
	NSLog(@"a: %@", a);
	id top = [a pop];
	TODSequence *p = [TODSequence sequence];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}


- (void)workOnOrAssembly:(TODAssembly *)a {
	NSLog(@"%s", _cmd);
	NSLog(@"a: %@", a);
	id top = [a pop];
	TODAlternation *p = [TODAlternation alternation];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}

@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize letterOrDigitParser;
@end
