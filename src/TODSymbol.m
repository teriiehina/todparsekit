//
//  TODSymbol.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODSymbol.h>
#import <TODParseKit/TODToken.h>

@interface TODSymbol ()
@property (nonatomic, retain) TODToken *symbol;
@end

@implementation TODSymbol

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
			self.symbol = [[[TODToken alloc] initWithTokenType:TODTT_SYMBOL stringValue:s floatValue:0.] autorelease];
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
		TODToken *tok = (TODToken *)obj;
		return tok.isSymbol;
	}
}


- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@) %@", [[self className] substringFromIndex:3], name, symbol.stringValue];
}

@synthesize symbol;
@end
