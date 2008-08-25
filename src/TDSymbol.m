//
//  TDSymbol.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSymbol.h>
#import <TDParseKit/TDToken.h>

@interface TDSymbol ()
@property (nonatomic, retain) TDToken *symbol;
@end

@implementation TDSymbol

+ (id)symbol {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)symbolWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		if (s.length) {
			self.symbol = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:s floatValue:0.0f];
		}
	}
	return self;
}


- (void)dealloc {
	self.symbol = nil;
	[super dealloc];
}


- (BOOL)qualifies:(id)obj {
	if (symbol) {
		return [symbol isEqual:obj];
	} else {
		TDToken *tok = (TDToken *)obj;
		return tok.isSymbol;
	}
}


- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@) %@", [[self className] substringFromIndex:3], name, symbol.stringValue];
}

@synthesize symbol;
@end
