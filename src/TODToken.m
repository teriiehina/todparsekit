//
//  TODToken.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODToken.h>

@interface TODTokenEOF : TODToken {}
@end

@implementation TODTokenEOF
- (NSString *)description {
	return [NSString stringWithFormat:@"<TODTokenEOF %p>", self];
}
@end

@interface TODToken ()
@property (nonatomic, readwrite, getter=isNumber) BOOL number;
@property (nonatomic, readwrite, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readwrite, getter=isSymbol) BOOL symbol;
@property (nonatomic, readwrite, getter=isWord) BOOL word;
@property (nonatomic, readwrite, getter=isWhitespace) BOOL whitespace;
@property (nonatomic, readwrite) CGFloat floatValue;
@property (nonatomic, readwrite, copy) NSString *stringValue;
@property (nonatomic, readwrite) TODTokenType tokenType;
@property (nonatomic, readwrite, copy) id value;
@end

@implementation TODToken

+ (TODToken *)EOFToken {
	static TODToken *EOFToken = nil;
	@synchronized (self) {
		if (!EOFToken) {
			EOFToken = [[TODTokenEOF alloc] initWithTokenType:TODTT_EOF stringValue:nil floatValue:0.];
		}
	}
	return EOFToken;
}


+ (id)tokenWithTokenType:(TODTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
	return [[[[self class] alloc] initWithTokenType:t stringValue:s floatValue:n] autorelease];
}


#pragma mark -

- (id)initWithFloatValue:(CGFloat)n {
	return [self initWithTokenType:TODTT_NUMBER
					   stringValue:[[NSNumber numberWithDouble:n] stringValue]
						floatValue:n];
}


- (id)initWithStringValue:(NSString *)s {
	return [self initWithTokenType:TODTT_WORD
					   stringValue:s
						floatValue:[s floatValue]];
}


// designated initializer
- (id)initWithTokenType:(TODTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
	self = [super init];
	if (self != nil) {
		self.tokenType = t;
		self.stringValue = s;
		self.floatValue = n;
		self.value = nil;
		
		self.number = (t == TODTT_NUMBER);
		self.quotedString = (t == TODTT_QUOTED);
		self.symbol = (t == TODTT_SYMBOL);
		self.word = (t == TODTT_WORD);
		self.whitespace = (t == TODTT_WHITESPACE);
		
		id v = nil;
		if (self.isNumber) {
			v = [NSNumber numberWithDouble:floatValue];
		} else if (self.isQuotedString) {
			v = stringValue;
		} else if (self.isSymbol) {
			v = stringValue;
		} else if (self.isWord) {
			v = stringValue;
		} else if (self.isWhitespace) {
			v = stringValue;
		}
		self.value = v;
	}
	return self;
}


- (void)dealloc {
	self.stringValue = nil;
	self.value = nil;
	[super dealloc];
}


- (NSUInteger)hash {
	return [stringValue hash];
}


- (BOOL)isEqual:(id)rhv {
	if (![rhv isMemberOfClass:[TODToken class]]) {
		return NO;
	}
	
	TODToken *that = (TODToken *)rhv;
	if (tokenType != that.tokenType) {
		return NO;
	}
	
	if (self.isNumber) {
		return floatValue == that.floatValue;
	} else {
		return [stringValue isEqualToString:that.stringValue];
	}
}


- (BOOL)isEqualIgnoringCase:(id)rhv {
	if (![rhv isMemberOfClass:[TODToken class]]) {
		return NO;
	}
	
	TODToken *that = (TODToken *)rhv;
	if (tokenType != that.tokenType) {
		return NO;
	}
	
	if (self.isNumber) {
		return floatValue == that.floatValue;
	} else {
		return [stringValue.lowercaseString isEqualToString:that.stringValue.lowercaseString];
	}
}


- (NSString *)debugDescription {
	NSString *typeString = nil;
	if (self.isNumber) {
		typeString = @"Number";
	} else if (self.isQuotedString) {
		typeString = @"Quoted String";
	} else if (self.isSymbol) {
		typeString = @"Symbol";
	} else if (self.isWord) {
		typeString = @"Word";
	} else if (self.isWhitespace) {
		typeString = @"Whitespace";
	}
	return [NSString stringWithFormat:@"<%@ %C%@%C>", typeString, 0x00ab, self.value, 0x00bb];
}


- (NSString *)description {
	return stringValue;
}


@synthesize number;
@synthesize quotedString;
@synthesize symbol;
@synthesize word;
@synthesize whitespace;
@synthesize floatValue;
@synthesize stringValue;
@synthesize tokenType;
@synthesize value;
@end
