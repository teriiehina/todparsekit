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

+ (id)literal {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)literalWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.literal = [[[TDToken alloc] initWithTokenType:TDTT_WORD stringValue:s floatValue:0.] autorelease];
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
	return [NSString stringWithFormat:@"%@ (%@) %@", [[self className] substringFromIndex:3], name, literal.stringValue];
}

@synthesize literal;
@end
