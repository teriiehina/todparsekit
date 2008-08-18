//
//  TODFastJsonParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODFastJsonParser.h"
#import "TODParseKit.h"

@interface TODFastJsonParser ()
- (void)workOnDictionary;
- (void)workOnArray;
- (NSArray *)objectsAbove:(id)fence;

@property (retain) TODTokenizer *tokenizer;
@property (retain) NSMutableArray *stack;
@property (retain) TODToken *curly;
@property (retain) TODToken *bracket;
@end

@implementation TODFastJsonParser

- (id)init {
	self = [super init];
	if (self != nil) {
		self.tokenizer = [TODTokenizer tokenizer];

		// configure tokenizer
		[tokenizer setCharacterState:tokenizer.symbolState from: '/' to: '/']; // JSON doesn't have slash slash or slash star comments
		[tokenizer setCharacterState:tokenizer.symbolState from: '\'' to: '\'']; // JSON does not have single quoted strings

		self.curly = [TODToken tokenWithTokenType:TODTT_SYMBOL stringValue:@"{" floatValue:0.0];
		self.bracket = [TODToken tokenWithTokenType:TODTT_SYMBOL stringValue:@"[" floatValue:0.0];
	}
	return self;
}


- (void)dealloc {
	self.tokenizer = nil;
	self.stack = nil;
	self.curly = nil;
	self.bracket = nil;
	[super dealloc];
}


- (id)parse:(NSString *)s {
	self.stack = [NSMutableArray array];
	
	tokenizer.string = s;
	TODToken *eof = [TODToken EOFToken];
	TODToken *tok = nil;
	
	while ((tok = [tokenizer nextToken]) != eof) {
		NSString *sval = tok.stringValue;
		
		if (tok.isSymbol) {
			if ([@"{" isEqualToString:sval]) {
				[stack addObject:tok];
			} else if ([@"}" isEqualToString:sval]) {
				[self workOnDictionary];
			} else if ([@"[" isEqualToString:sval]) {
				[stack addObject:tok];
			} else if ([@"]" isEqualToString:sval]) {
				[self workOnArray];
			}
		} else {
			id value = nil;
			if (tok.isQuotedString) {
				value = [sval stringByRemovingFirstAndLastCharacters];
			} else if (tok.isNumber) {
				value = [NSNumber numberWithFloat:tok.floatValue];
			} else { // if (tok.isWord) {
				if ([@"null" isEqualToString:sval]) {
					value = [NSNull null];
				} else if ([@"true" isEqualToString:sval]) {
					value = [NSNumber numberWithBool:YES];
				} else if ([@"false" isEqualToString:sval]) {
					value = [NSNumber numberWithBool:NO];
				}
			}
			[stack addObject:value];
		}
	}
	
	return [stack lastObject];
}


- (void)workOnDictionary {
	NSArray *a = [self objectsAbove:curly];
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:a.count/2.];
	
	NSInteger i = a.count - 1;
	for ( ; i >= 0; i--) {
		NSString *key = [a objectAtIndex:i--];
		id value = [a objectAtIndex:i];
		[result setObject:value forKey:key];
	}
	
	[stack addObject:result];
}


- (void)workOnArray {
	NSArray *a = [self objectsAbove:bracket];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:a.count];
	NSEnumerator *e = [a reverseObjectEnumerator];
	id obj = nil;
	while (obj = [e nextObject]) {
		[result addObject:obj];
	}
	[stack addObject:result];
}


- (NSArray *)objectsAbove:(id)fence {
	NSMutableArray *result = [NSMutableArray array];
	while (1) {
		id obj = [stack lastObject];
		[stack removeLastObject];
		if ([obj isEqual:fence]) {
			break;
		}
		[result addObject:obj];
	}
	return result;
}

@synthesize stack;
@synthesize tokenizer;
@synthesize curly;
@synthesize bracket;
@end
