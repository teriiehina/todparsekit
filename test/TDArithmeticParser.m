//
//  TDArithmeticParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDArithmeticParser.h"

// expr				= term (plusTerm | minusTerm)*
// term				= factor (timesFactor | divFactor)*
// plusTerm			= '+' term
// minusTerm		= '-' term
// factor			= phrase exponentFactor | phrase
// timesFactor		= '*' factor
// divFactor		= '/' factor
// exponentFactor	= '^' factor
// phrase			= '(' expr ')' | Num

@implementation TDArithmeticParser

- (id)init {
	self = [super init];
	if (self != nil) {
		[self add:self.exprParser];
	}
	return self;
}


- (void)dealloc {
	self.exprParser = nil;
	self.termParser = nil;
	self.plusTermParser = nil;
	self.minusTermParser = nil;
	self.factorParser = nil;
	self.timesFactorParser = nil;
	self.divFactorParser = nil;
	self.exponentFactorParser = nil;
	self.phraseParser = nil;
	[super dealloc];
}


- (CGFloat)parse:(NSString *)s {
	TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
	a = [self completeMatchFor:a];
//	NSLog(@"\n\na: %@\n\n", a);
	return [[a pop] floatValue];
}


// expr			= term (plusTerm | minusTerm)*
- (TDCollectionParser *)exprParser {
	if (!exprParser) {
		self.exprParser = [TDSequence sequence];
		[exprParser add:self.termParser];
		
		TDAlternation *a = [TDAlternation alternation];
		[a add:self.plusTermParser];
		[a add:self.minusTermParser];
		
		[exprParser add:[TDRepetition repetitionWithSubparser:a]];
	}
	return exprParser;
}


// term			= factor (timesFactor | divFactor)*
- (TDCollectionParser *)termParser {
	if (!termParser) {
		self.termParser = [TDSequence sequence];
		[termParser add:self.factorParser];
		
		TDAlternation *a = [TDAlternation alternation];
		[a add:self.timesFactorParser];
		[a add:self.divFactorParser];
		
		[termParser add:[TDRepetition repetitionWithSubparser:a]];
	}
	return termParser;
}


// plusTerm		= '+' term
- (TDCollectionParser *)plusTermParser {
	if (!plusTermParser) {
		self.plusTermParser = [TDSequence sequence];
		[plusTermParser add:[[TDSymbol symbolWithString:@"+"] discard]];
		[plusTermParser add:self.termParser];
		[plusTermParser setAssembler:self selector:@selector(workOnPlusAssembly:)];
	}
	return plusTermParser;
}


// minusTerm	= '-' term
- (TDCollectionParser *)minusTermParser {
	if (!minusTermParser) {
		self.minusTermParser = [TDSequence sequence];
		[minusTermParser add:[[TDSymbol symbolWithString:@"-"] discard]];
		[minusTermParser add:self.termParser];
		[minusTermParser setAssembler:self selector:@selector(workOnMinusAssembly:)];
	}
	return minusTermParser;
}


// factor		= phrase exponentFactor | phrase
- (TDCollectionParser *)factorParser {
	if (!factorParser) {
		self.factorParser = [TDAlternation alternation];
		
		TDSequence *s = [TDSequence sequence];
		[s add:self.phraseParser];
		[s add:self.exponentFactorParser];
		
		[factorParser add:s];
		[factorParser add:self.phraseParser];
	}
	return factorParser;
}


// timesFactor	= '*' factor
- (TDCollectionParser *)timesFactorParser {
	if (!timesFactorParser) {
		self.timesFactorParser = [TDSequence sequence];
		[timesFactorParser add:[[TDSymbol symbolWithString:@"*"] discard]];
		[timesFactorParser add:self.factorParser];
		[timesFactorParser setAssembler:self selector:@selector(workOnTimesAssembly:)];
	}
	return timesFactorParser;
}


// divFactor	= '/' factor
- (TDCollectionParser *)divFactorParser {
	if (!divFactorParser) {
		self.divFactorParser = [TDSequence sequence];
		[divFactorParser add:[[TDSymbol symbolWithString:@"/"] discard]];
		[divFactorParser add:self.factorParser];
		[divFactorParser setAssembler:self selector:@selector(workOnDivideAssembly:)];
	}
	return divFactorParser;
}


// exponentFactor	= '^' factor
- (TDCollectionParser *)exponentFactorParser {
	if (!exponentFactorParser) {
		self.exponentFactorParser = [TDSequence sequence];
		[exponentFactorParser add:[[TDSymbol symbolWithString:@"^"] discard]];
		[exponentFactorParser add:self.factorParser];
		[exponentFactorParser setAssembler:self selector:@selector(workOnExpAssembly:)];
	}
	return exponentFactorParser;
}


// phrase		= '(' expr ')' | Num
- (TDCollectionParser *)phraseParser {
	if (!phraseParser) {
		self.phraseParser = [TDAlternation alternation];
		
		TDSequence *s = [TDSequence sequence];
		[s add:[[TDSymbol symbolWithString:@"("] discard]];
		[s add:self.exprParser];
		[s add:[[TDSymbol symbolWithString:@")"] discard]];
		
		[phraseParser add:s];
		
		TDNum *n = [TDNum num];
//		[n setAssembler:self selector:@selector(workOnNumAssembly:)];
		[phraseParser add:n];
	}
	return phraseParser;
}


#pragma mark -
#pragma mark Assembler

//- (void)workOnNumAssembly:(TDAssembly *)a {
//	TDToken *tok = [a pop];
//	[a push:[NSNumber numberWithFloat:tok.floatValue]];
//}


- (void)workOnPlusAssembly:(TDAssembly *)a {
	TDToken *tok2 = [a pop];
	TDToken *tok1 = [a pop];
	[a push:[NSNumber numberWithFloat:tok1.floatValue + tok2.floatValue]];
}


- (void)workOnMinusAssembly:(TDAssembly *)a {
	TDToken *tok2 = [a pop];
	TDToken *tok1 = [a pop];
	[a push:[NSNumber numberWithFloat:tok1.floatValue - tok2.floatValue]];
}


- (void)workOnTimesAssembly:(TDAssembly *)a {
	TDToken *tok2 = [a pop];
	TDToken *tok1 = [a pop];
	[a push:[NSNumber numberWithFloat:tok1.floatValue * tok2.floatValue]];
}


- (void)workOnDivideAssembly:(TDAssembly *)a {
	TDToken *tok2 = [a pop];
	TDToken *tok1 = [a pop];
	[a push:[NSNumber numberWithFloat:tok1.floatValue / tok2.floatValue]];
}


- (void)workOnExpAssembly:(TDAssembly *)a {
	TDToken *tok2 = [a pop];
	TDToken *tok1 = [a pop];
	
	CGFloat n1 = tok1.floatValue;
	CGFloat n2 = tok2.floatValue;
	
	CGFloat res = n1;
	NSInteger i = 1;
	for ( ; i < n2; i++) {
		res *= n1;
	}
	
	[a push:[NSNumber numberWithFloat:res]];
}

@synthesize exprParser;
@synthesize termParser;
@synthesize plusTermParser;
@synthesize minusTermParser;
@synthesize factorParser;
@synthesize timesFactorParser;
@synthesize divFactorParser;
@synthesize exponentFactorParser;
@synthesize phraseParser;
@end
