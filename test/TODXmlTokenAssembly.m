//
//  TODXmlTokenAssembly.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTokenAssembly.h"
#import "TODXmlTokenizer.h"
#import "TODXmlToken.h"

@interface TODXmlTokenAssembly ()
- (void)tokenize;

@property (nonatomic, retain) NSMutableArray *tokens;
@end

@implementation TODXmlTokenAssembly

- (id)init {
	return nil;
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.tokenizer = [[[TODXmlTokenizer alloc] initWithContentsOfFile:s] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.tokenizer = nil;
	self.tokens = nil;
	[super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
	TODXmlTokenAssembly *a = (TODXmlTokenAssembly *)[super copyWithZone:zone];
	a->tokens = [self.tokens mutableCopy];
    return a;
}


- (NSMutableArray *)tokens {
	if (!tokens) {
		[self tokenize];
	}
	return [[tokens retain] autorelease];
}


- (void)setTokens:(NSMutableArray *)inArray {
	if (inArray != tokens) {
		[tokens autorelease];
		tokens = [inArray retain];
	}
}


- (void)tokenize {
	self.tokens = [NSMutableArray array];
	
	TODXmlToken *eof = [TODXmlToken EOFToken];
	TODXmlToken *tok = nil;
	while ((tok = [tokenizer nextToken]) != eof) {
		[tokens addObject:tok];
	}
}


- (id)peek {
	if (index >= self.tokens.count) {
		return nil;
	}
	id tok = [self.tokens objectAtIndex:index];
	
	return tok;
}


- (id)next {
	id tok = [self peek];
	if (tok) {
		index++;
	}
	return tok;
}


- (BOOL)hasMore {
	return (index < self.tokens.count);
}


- (NSInteger)length {
	return self.tokens.count;
} 


- (NSInteger)objectsConsumed {
	return index;
}


- (NSInteger)objectsRemaining {
	return (self.tokens.count - index);
}


- (NSString *)consumed:(NSString *)delimiter {
	NSMutableString *s = [NSMutableString string];
	
	NSInteger i = 0;
	NSInteger len = self.objectsConsumed;
	
	for ( ; i < len; i++) {
		TODXmlToken *tok = [self.tokens objectAtIndex:i];
		[s appendString:tok.stringValue];
		if (i != len - 1) {
			[s appendString:delimiter];
		}
	}
	
	return [[s copy] autorelease];
}


- (NSString *)remainder:(NSString *)delimiter {
	NSMutableString *s = [NSMutableString string];
	
	NSInteger i = self.objectsConsumed;
	NSInteger len = self.length;
	
	for ( ; i < len; i++) {
		TODXmlToken *tok = [self.tokens objectAtIndex:i];
		[s appendString:tok.stringValue];
		if (i != len - 1) {
			[s appendString:delimiter];
		}
	}
	return [[s copy] autorelease];
}

@synthesize tokenizer;
@end
