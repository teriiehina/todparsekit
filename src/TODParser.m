//
//  TODParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODParser.h"
#import "TODAssembly.h"

@implementation NSString (TODParseKitAdditions)

- (NSString *)stringByRemovingFirstAndLastCharacters {
	if (self.length < 2) {
		return self;
	} else {
		return [[self substringFromIndex:1] substringToIndex:self.length-2];
	}
}

@end

@interface TODParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TODAssembly *)best:(NSSet *)inAssemblies;
@end

@implementation TODParser

+ (id)parser {
	return [[[[self class] alloc] init] autorelease];
}


+ (NSSet *)deepCopy:(NSSet *)inSet {
	return [[NSSet alloc] initWithSet:inSet copyItems:YES];
}


- (id)init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (void)dealloc {
	self.assembler = nil;
	self.selector = nil;
	self.name = nil;
	[super dealloc];
}


- (void)setAssembler:(id)a selector:(SEL)sel {
	self.assembler = a;
	self.selector = sel;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	NSAssert1(0, @"-[TODParser %s] must be overriden", _cmd);
	return nil;
}


- (TODAssembly *)bestMatchFor:(TODAssembly *)a {
	NSSet *initialState = [NSSet setWithObject:a];
	NSSet *finalState = [self matchAndAssemble:initialState];
	return [self best:finalState];
}


- (TODAssembly *)completeMatchFor:(TODAssembly *)a {
	TODAssembly *best = [self bestMatchFor:a];
	if (best && ![best hasMore]) {
		return best;
	}
	return nil;
}


- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies {
	NSSet *outAssemblies = [self allMatchesFor:inAssemblies];
	if (assembler) {
	//if (assembler && [assembler respondsToSelector:selector]) {
		for (TODAssembly *a in outAssemblies) {
			[assembler performSelector:selector withObject:a];
		}
	}
	return outAssemblies;
}


- (TODAssembly *)best:(NSSet *)inAssemblies {
	TODAssembly *best = nil;
	
	for (TODAssembly *a in inAssemblies) {
		if (![a hasMore]) {
			best = a;
			break;
		}
		if (!best) {
			best = a;
		} else if ([a objectsConsumed] > [best objectsConsumed]) {
			best = a;
		}
	}
	
	return best;
}


- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@)", [[self className] substringFromIndex:3], name];
}

@synthesize assembler;
@synthesize selector;
@synthesize name;
@end
