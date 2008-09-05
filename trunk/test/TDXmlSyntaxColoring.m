//
//  TDXmlSyntaxColoring.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDXmlSyntaxColoring.h"
#import "TDParseKit.h"

@interface TDXmlSyntaxColoring ()
- (void)workOnTag;
- (void)workOnText;
- (NSArray *)objectsAbove:(id)fence;

@property (retain) TDTokenizer *tokenizer;
@property (retain) NSMutableArray *stack;
@property (retain) TDToken *ltToken;
@property (retain) TDToken *gtToken;
@end

@implementation TDXmlSyntaxColoring

- (id)init {
	self = [super init];
	if (self != nil) {
		self.tokenizer = [TDTokenizer tokenizer];
		
		// configure tokenizer
		[tokenizer setTokenizerState:tokenizer.symbolState from: '/' to: '/']; // JSON doesn't have slash slash or slash star comments
		[tokenizer setTokenizerState:tokenizer.symbolState from: '\'' to: '\'']; // JSON does not have single quoted strings
		
		self.ltToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@"{" floatValue:0.0];
		self.gtToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@"[" floatValue:0.0];
		
		self.textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSColor blackColor], NSForegroundColorAttributeName,
							   nil];
		
		NSFont *boldFont = [NSFont boldSystemFontOfSize:-1];
		self.tagAttributes  = [NSDictionary dictionaryWithObjectsAndKeys:
							   boldFont, NSFontAttributeName,
							   [NSColor purpleColor], NSForegroundColorAttributeName,
							   nil];
	}
	return self;
}


- (void)dealloc {
	self.tokenizer = nil;
	self.stack = nil;
	self.ltToken = nil;
	self.gtToken = nil;
	self.result = nil;
	self.textAttributes = nil;
	self.tagAttributes = nil;
	[super dealloc];
}


- (NSAttributedString *)parse:(NSString *)s {
	self.stack = [NSMutableArray array];
	self.result = [[[NSMutableAttributedString alloc] init] autorelease];
	
	tokenizer.string = s;
	TDToken *eof = [TDToken EOFToken];
	TDToken *tok = nil;
	
	while ((tok = [tokenizer nextToken]) != eof) {
		NSString *sval = tok.stringValue;
		
		if (tok.isSymbol) {
			if ([@"<" isEqualToString:sval]) {
				[self workOnText];
				[stack addObject:tok];
			} else if ([@">" isEqualToString:sval]) {
				[self workOnTag];
			}
		} else {
			[stack addObject:sval];
		}
	}
	
	return result;
}


- (void)workOnTag {
	NSArray *a = [self objectsAbove:ltToken];
	NSEnumerator *e = [a reverseObjectEnumerator];
	NSString *s = nil;
	while (s = [e nextObject]) {
		NSAttributedString *as = [[NSAttributedString alloc] initWithString:s attributes:tagAttributes];
		[result appendAttributedString:as];
		[as release];
	}
}


- (void)workOnText {
	NSArray *a = [self objectsAbove:gtToken];
	NSEnumerator *e = [a reverseObjectEnumerator];
	NSString *s = nil;
	while (s = [e nextObject]) {
		NSAttributedString *as = [[NSAttributedString alloc] initWithString:s attributes:textAttributes];
		[result appendAttributedString:as];
		[as release];
	}
}


- (NSArray *)objectsAbove:(id)fence {
	NSMutableArray *res = [NSMutableArray array];
	while (1) {
		if (!stack.count) {
			break;
		}
		id obj = [stack lastObject];
		[stack removeLastObject];
		if ([obj isEqual:fence]) {
			break;
		}
		[res addObject:obj];
	}
	return res;
}

@synthesize stack;
@synthesize tokenizer;
@synthesize ltToken;
@synthesize gtToken;
@synthesize result;
@synthesize tagAttributes;
@synthesize textAttributes;
@end
