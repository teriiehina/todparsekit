//
//  TODJsonParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODJsonParser.h"
#import "TODParseKit.h"

@interface TODJsonParser ()
@property (retain) TODToken *curly;
@property (retain) TODToken *bracket;
@end

@implementation TODJsonParser

- (id)init {
	self = [super init];
	if (self != nil) {
		self.curly = [[[TODToken alloc] initWithTokenType:TODTT_SYMBOL stringValue:@"{" floatValue:0.0] autorelease];
		self.bracket = [[[TODToken alloc] initWithTokenType:TODTT_SYMBOL stringValue:@"[" floatValue:0.0] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.stringParser = nil;
	self.numberParser = nil;
	self.nullParser = nil;
	self.booleanParser = nil;
	self.arrayParser = nil;
	self.objectParser = nil;
	self.valueParser = nil;
	self.propertyParser = nil;
	self.commaPropertyParser = nil;
	self.commaValueParser = nil;
	self.curly = nil;
	self.bracket = nil;
	[super dealloc];
}


- (id)parse:(NSString *)s {
	[self add:[TODEmpty empty]];
	[self add:self.arrayParser];
	[self add:self.objectParser];
	
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODTokenizer *tokenizer = a.tokenizer;
	[tokenizer setCharacterState:tokenizer.symbolState from: '/' to: '/']; // JSON doesn't have slash slash or slash star comments
	[tokenizer setCharacterState:tokenizer.symbolState from: '\'' to: '\'']; // JSON does not have single quoted strings

	TODAssembly *result = [self completeMatchFor:a];
	return [result pop];
}


- (TODParser *)stringParser {
	if (!stringParser) {
		self.stringParser = [TODQuotedString quotedString];
		[stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
	}
	return stringParser;
}


- (TODParser *)numberParser {
	if (!numberParser) {
		self.numberParser = [TODNum num];
		[numberParser setAssembler:self selector:@selector(workOnNumberAssembly:)];
	}
	return numberParser;
}


- (TODParser *)nullParser {
	if (!nullParser) {
		self.nullParser = [[TODLiteral literalWithString:@"null"] discard];
		[nullParser setAssembler:self selector:@selector(workOnNullAssembly:)];
	}
	return nullParser;
}


- (TODParser *)booleanParser {
	if (!booleanParser) {
		self.booleanParser = [TODAlternation alternation];
		[booleanParser add:[TODLiteral literalWithString:@"true"]];
		[booleanParser add:[TODLiteral literalWithString:@"false"]];
		[booleanParser setAssembler:self selector:@selector(workOnBooleanAssembly:)];
	}
	return booleanParser;
}


- (TODParser *)arrayParser {
	if (!arrayParser) {

		// array = '[' content ']'
		// content = Empty | actualArray
		// actualArray = value commaValue*

		TODTrack *actualArray = [TODTrack sequence];
		[actualArray add:self.valueParser];
		[actualArray add:[TODRepetition repetitionWithSubparser:self.commaValueParser]];

		TODAlternation *content = [TODAlternation alternation];
		[content add:[TODEmpty empty]];
		[content add:actualArray];
		
		self.arrayParser = [TODSequence sequence];
		[arrayParser add:[TODSymbol symbolWithString:@"["]];
		[arrayParser add:content];
		[arrayParser add:[[TODSymbol symbolWithString:@"]"] discard]];
		
		[arrayParser setAssembler:self selector:@selector(workOnArrayAssembly:)];
	}
	return arrayParser;
}


- (TODParser *)objectParser {
	if (!objectParser) {
		
		// object = '{' content '}'
		// content = Empty | actualObject
		// actualObject = property commaProperty*
		// property = QuotedString ':' value
		// commaProperty = ',' property
		
		TODTrack *actualObject = [TODTrack sequence];
		[actualObject add:self.propertyParser];
		[actualObject add:[TODRepetition repetitionWithSubparser:self.commaPropertyParser]];
		
		TODAlternation *content = [TODAlternation alternation];
		[content add:[TODEmpty empty]];
		[content add:actualObject];
		
		self.objectParser = [TODSequence sequence];
		[objectParser add:[TODSymbol symbolWithString:@"{"]];
		[objectParser add:content];
		[objectParser add:[[TODSymbol symbolWithString:@"}"] discard]];

		[objectParser setAssembler:self selector:@selector(workOnObjectAssembly:)];
	}
	return objectParser;
}


- (TODParser *)valueParser {
	if (!valueParser) {
		self.valueParser = [TODAlternation alternation];
		[valueParser add:self.stringParser];
		[valueParser add:self.numberParser];
		[valueParser add:self.nullParser];
		[valueParser add:self.booleanParser];
		[valueParser add:self.arrayParser];
		[valueParser add:self.objectParser];
	}
	return valueParser;
}


- (TODParser *)commaValueParser {
	if (!commaValueParser) {
		self.commaValueParser = [TODTrack sequence];
		[commaValueParser add:[[TODSymbol symbolWithString:@","] discard]];
		[commaValueParser add:self.valueParser];
	}
	return commaValueParser;
}


- (TODParser *)propertyParser {
	if (!propertyParser) {
		self.propertyParser = [TODSequence sequence];
		[propertyParser add:[TODQuotedString quotedString]];
		[propertyParser add:[[TODSymbol symbolWithString:@":"] discard]];
		[propertyParser add:self.valueParser];
		[propertyParser setAssembler:self selector:@selector(workOnPropertyAssembly:)];
	}
	return propertyParser;
}


- (TODParser *)commaPropertyParser {
	if (!commaPropertyParser) {
		self.commaPropertyParser = [TODTrack sequence];
		[commaPropertyParser add:[[TODSymbol symbolWithString:@","] discard]];
		[commaPropertyParser add:self.propertyParser];
	}
	return commaPropertyParser;
}


- (void)workOnNullAssembly:(TODAssembly *)a {
	[a push:[NSNull null]];
}


- (void)workOnNumberAssembly:(TODAssembly *)a {
	TODToken *tok = [a pop];
	[a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnStringAssembly:(TODAssembly *)a {
	TODToken *tok = [a pop];
	[a push:[tok.stringValue stringByRemovingFirstAndLastCharacters]];
}


- (void)workOnBooleanAssembly:(TODAssembly *)a {
	TODToken *tok = [a pop];
	[a push:[NSNumber numberWithBool:[tok.stringValue isEqualToString:@"true"] ? YES : NO]];
}


- (void)workOnArrayAssembly:(TODAssembly *)a {
	NSArray *elements = [a objectsAbove:self.bracket];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:elements.count];
	
	NSEnumerator *e = [elements reverseObjectEnumerator];
	id element = nil;
	while (element = [e nextObject]) {
		if (element) {
			[array addObject:element];
		}
	}
	[a pop]; // pop the [
	[a push:array];
}


- (void)workOnObjectAssembly:(TODAssembly *)a {
	NSArray *elements = [a objectsAbove:self.curly];
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	NSInteger i = 0;
	for ( ; i < elements.count - 1; i++) {
		id value = [elements objectAtIndex:i++];
		NSString *key = [elements objectAtIndex:i];
		if (key && value) {
			[d setObject:value forKey:key];
		}
	}
	
	[a pop]; // pop the {
	[a push:d];
}


- (void)workOnPropertyAssembly:(TODAssembly *)a {
	id value = [a pop];
	TODToken *tok = [a pop];
	NSString *key = [tok.stringValue stringByRemovingFirstAndLastCharacters];
	
	[a push:key];
	[a push:value];
}

@synthesize stringParser;
@synthesize numberParser;
@synthesize nullParser;
@synthesize booleanParser;
@synthesize arrayParser;
@synthesize objectParser;
@synthesize valueParser;
@synthesize commaValueParser;
@synthesize propertyParser;
@synthesize commaPropertyParser;
@synthesize curly;
@synthesize bracket;
@end
