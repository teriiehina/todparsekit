//
//  TODStructure.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODStructure.h"


@implementation TODStructure

+ (id)structureWithFunctor:(id)f terms:(NSArray *)t {
	return [[[[self class] alloc] initWithFunctor:f terms:t] autorelease];
}


- (id)initWithFunctor:(id)f terms:(NSArray *)t {
	self = [super init];
	if (self != nil) {
		self.functor = f;
		self.terms = t;
	}
	return self;
}


- (void)dealloc {
	self.functor = nil;
	self.terms = nil;
	[super dealloc];
}


- (void)unify:(TODStructure *)s {
	if (![functor isEqual:s.functor]) {
		return;
	}
	
	if (terms.count != s.terms.count) {
		return;
	}
	
	
}


- (NSString *)description {
	NSMutableString *s = [NSMutableString stringWithString:[functor description]];
	NSInteger n = terms.count;
	if (n) {
		[s appendString:@"("];
		NSInteger i = 0;
		for (id <TODTerm> term in terms) {
			[s appendString:[term description]];
			if (i < n - 1) {
				[s appendString:@","];
			}
		}
		[s appendString:@")"];
	}
	return [[s copy] autorelease];
}

@synthesize functor;
@synthesize terms;
@end
