//
//  Query.m
//  Documents
//
//  Created by Jesse Grosjean on 5/27/09.
//  Copyright 2009 Hog Bay Software. All rights reserved.
//

#import "QueryParser.h"

// expression = andTerm
// andTerm = orTerm ('and' orTerm)*
// orTerm = notFactor ('or' notFactor)*
// notFactor = 'not' factor | factor
// factor = '(' expression ')' | predicate
// predicate = 'true' | 'false'

@implementation QueryParser

- (id)init {
    if (self = [super init]) {
        [self add:self.expressionParser];
    }
    return self;
}

- (void)dealloc {
    self.expressionParser = nil;
	self.andTermParser = nil;
    self.orTermParser = nil;
	self.notFactorParser = nil;
    self.factorParser = nil;
    self.predicateParser = nil;
    [super dealloc];
}

- (NSPredicate *)parse:(NSString *)s {
    return [[self completeMatchFor:[TDTokenAssembly assemblyWithString:s]] pop];
}

@synthesize expressionParser;
@synthesize andTermParser;
@synthesize orTermParser;
@synthesize notFactorParser;
@synthesize factorParser;
@synthesize predicateParser;

// expression = andTerm
- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        self.expressionParser = [TDSequence sequence];
        [expressionParser add:self.andTermParser];
    }
    return expressionParser;
}

// andTerm = orTerm ('and' orTerm)*
- (TDCollectionParser *)andTermParser {
	if (!andTermParser) {
		self.andTermParser = [TDSequence sequence];
		
		[andTermParser add:self.orTermParser];
		
		TDSequence *s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"and"]];
		[s add:self.orTermParser];
        
        [andTermParser add:[TDRepetition repetitionWithSubparser:s]];
		[andTermParser setAssembler:self selector:@selector(workOnAndAssembly:)];
	}
	return andTermParser;
}

// orTerm = notFactor ('or' notFactor)*
- (TDCollectionParser *)orTermParser {
	if (!orTermParser) {
		self.orTermParser = [TDSequence sequence];

		[orTermParser add:self.notFactorParser];
		
		TDSequence *s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"or"]];
		[s add:self.notFactorParser];
        
        [orTermParser add:[TDRepetition repetitionWithSubparser:s]];		
		[orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
	}
	return orTermParser;
}

// notFactor = 'not' factor | factor
- (TDCollectionParser *)notFactorParser {
	if (!notFactorParser) {
		self.notFactorParser = [TDAlternation alternation];

		[notFactorParser add:self.factorParser];
		
		TDSequence *s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"not"]];
		[s add:self.factorParser];
        
        [notFactorParser add:s];
		[notFactorParser setAssembler:self selector:@selector(workOnNotAssembly:)];
	}
	return notFactorParser;
}

// factor = '(' expression ')' | predicate
- (TDCollectionParser *)factorParser {
	if (!factorParser) {
		self.factorParser = [TDAlternation alternation];
		
		TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.expressionParser];
        [s add:[TDSymbol symbolWithString:@")"]];
        
        [factorParser add:s];
        [factorParser add:self.predicateParser];
		[factorParser setAssembler:self selector:@selector(workOnFactorAssembly:)];
	}
	return factorParser;
}

// predicate = 'true' | 'false'
- (TDCollectionParser *)predicateParser {
	if (!predicateParser) {
		self.predicateParser = [TDAlternation alternation];
		[predicateParser add:[TDLiteral literalWithString:@"true"]];
		[predicateParser add:[TDLiteral literalWithString:@"false"]];
		[predicateParser setAssembler:self selector:@selector(workOnPredicateAssembly:)];
	}
	return predicateParser;
}


#pragma mark -
#pragma mark Assembler

- (void)workOnAndAssembly:(TDAssembly *)a {
	NSArray *stack = a.stack;
	if ([stack count] > 2) {
		TDToken *possibleAnd = [stack objectAtIndex:[stack count] - 2];
		if ([possibleAnd isKindOfClass:[TDToken class]] && [[possibleAnd stringValue] isEqualToString:@"and"]) {
			NSMutableArray *andPredicates = [NSMutableArray arrayWithCapacity:2];
			
			[andPredicates insertObject:[a pop] atIndex:0];
			[a pop]; // and
			[andPredicates insertObject:[a pop] atIndex:0];
			
			BOOL findingAnds = YES;
			
			while ([stack count] > 1 && findingAnds) {
				possibleAnd = [stack lastObject];
				if ([possibleAnd isKindOfClass:[TDToken class]] && [[possibleAnd stringValue] isEqualToString:@"and"]) {
					[a pop];
					[andPredicates insertObject:[a pop] atIndex:0];
				} else {
					findingAnds = NO;
				}
			}
			
			[a push:[NSCompoundPredicate andPredicateWithSubpredicates:andPredicates]];
		}
	}
}


- (void)workOnOrAssembly:(TDAssembly *)a {
	NSArray *stack = a.stack;
	if ([stack count] > 2) {
		TDToken *possibleOr = [stack objectAtIndex:[stack count] - 2];
		if ([possibleOr isKindOfClass:[TDToken class]] && [[possibleOr stringValue] isEqualToString:@"or"]) {
			NSMutableArray *orPredicates = [NSMutableArray arrayWithCapacity:2];
			
			[orPredicates insertObject:[a pop] atIndex:0];
			[a pop]; // or
			[orPredicates insertObject:[a pop] atIndex:0];
			
			BOOL findingOrs = YES;
			
			while ([stack count] > 1 && findingOrs) {
				possibleOr = [stack lastObject];
				if ([possibleOr isKindOfClass:[TDToken class]] && [[possibleOr stringValue] isEqualToString:@"or"]) {
					[a pop];
					[orPredicates insertObject:[a pop] atIndex:0];
				} else {
					findingOrs = NO;
				}
			}
			
			[a push:[NSCompoundPredicate orPredicateWithSubpredicates:orPredicates]];
		}
	}
}

- (void)workOnNotAssembly:(TDAssembly *)a {
	NSArray *stack = a.stack;
	if ([stack count] > 1) {
		TDToken *possibleNot = [stack objectAtIndex:[stack count] - 2];
		if ([possibleNot isKindOfClass:[TDToken class]] && [[possibleNot stringValue] isEqualToString:@"not"]) {
			NSPredicate *predicate = [a pop];
			[a pop]; // pop not
			[a push:[NSCompoundPredicate notPredicateWithSubpredicate:predicate]];
		}
	}
}

- (void)workOnFactorAssembly:(TDAssembly *)a {
	NSArray *stack = a.stack;
	TDToken *possibleEndParenthese = [stack lastObject];
	if ([possibleEndParenthese isKindOfClass:[TDToken class]] && [[possibleEndParenthese stringValue] isEqualToString:@")"]) {
		[a pop];
		id factor = [a pop];
		[a pop];
		[a push:factor];
	}
}

- (void)workOnPredicateAssembly:(TDAssembly *)a {
    TDToken *token = [a pop];
	
	if ([token.stringValue isEqualToString:@"true"]) {
		[a push:[NSPredicate predicateWithValue:YES]];
	} else {
		[a push:[NSPredicate predicateWithValue:NO]];
	}
}

@end
