//
//  TDLiteral.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDLiteral.h>
#import <TDParseKit/TDToken.h>

@interface TDLiteral ()
@property (nonatomic, retain) TDToken *literal;
@end

@implementation TDLiteral

+ (id)literalWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.literal = [TDToken tokenWithTokenType:TDTT_WORD stringValue:s floatValue:0.0f];
	}
	return self;
}


- (void)dealloc {
	self.literal = nil;
	[super dealloc];
}


- (BOOL)qualifies:(id)obj {
	return [literal isEqual:obj];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@) %@", [[self className] substringFromIndex:2], name, literal.stringValue];
}

@synthesize literal;
@end
