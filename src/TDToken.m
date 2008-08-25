//
//  TDToken.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDToken.h>

@interface TDTokenEOF : TDToken {}
@end

@implementation TDTokenEOF
- (NSString *)description {
	return [NSString stringWithFormat:@"<TDTokenEOF %p>", self];
}
@end

@interface TDToken ()
@property (nonatomic, readwrite, getter=isNumber) BOOL number;
@property (nonatomic, readwrite, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readwrite, getter=isSymbol) BOOL symbol;
@property (nonatomic, readwrite, getter=isWord) BOOL word;

@property (nonatomic, readwrite) CGFloat floatValue;
@property (nonatomic, readwrite, copy) NSString *stringValue;
@property (nonatomic, readwrite) TDTokenType tokenType;
@property (nonatomic, readwrite, copy) id value;
@end

@implementation TDToken

+ (TDToken *)EOFToken {
	static TDToken *EOFToken = nil;
	@synchronized (self) {
		if (!EOFToken) {
			EOFToken = [[TDTokenEOF alloc] initWithTokenType:TDTT_EOF stringValue:nil floatValue:0.0f];
		}
	}
	return EOFToken;
}


+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
	return [[[[self class] alloc] initWithTokenType:t stringValue:s floatValue:n] autorelease];
}


#pragma mark -

- (id)initWithFloatValue:(CGFloat)n {
	return [self initWithTokenType:TDTT_NUMBER
					   stringValue:[[NSNumber numberWithFloat:n] stringValue]
						floatValue:n];
}


- (id)initWithStringValue:(NSString *)s {
	return [self initWithTokenType:TDTT_WORD
					   stringValue:s
						floatValue:[s floatValue]];
}


// designated initializer
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
	self = [super init];
	if (self != nil) {
		self.tokenType = t;
		self.stringValue = s;
		self.floatValue = n;
		
		self.number = (t == TDTT_NUMBER);
		self.quotedString = (t == TDTT_QUOTED);
		self.symbol = (t == TDTT_SYMBOL);
		self.word = (t == TDTT_WORD);
		
		id v = nil;
		if (self.isNumber) {
			v = [NSNumber numberWithFloat:floatValue];
		} else if (self.isQuotedString) {
			v = stringValue;
		} else if (self.isSymbol) {
			v = stringValue;
		} else if (self.isWord) {
			v = stringValue;
		} else { // support for token type extensions
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
	if (![rhv isMemberOfClass:[TDToken class]]) {
		return NO;
	}
	
	TDToken *that = (TDToken *)rhv;
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
	if (![rhv isMemberOfClass:[TDToken class]]) {
		return NO;
	}
	
	TDToken *that = (TDToken *)rhv;
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
@synthesize floatValue;
@synthesize stringValue;
@synthesize tokenType;
@synthesize value;
@end
