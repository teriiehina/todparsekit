//
//  TDParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParser.h>
#import <TDParseKit/TDAssembly.h>

@implementation NSString (TDParseKitAdditions)

- (NSString *)stringByRemovingFirstAndLastCharacters {
	if (self.length < 2) {
		return self;
	} else {
		return [[self substringFromIndex:1] substringToIndex:self.length-2];
	}
}

@end

@interface TDParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TDAssembly *)best:(NSSet *)inAssemblies;
@end

@implementation TDParser

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
	NSAssert1(0, @"-[TDParser %s] must be overriden", _cmd);
	return nil;
}


- (TDAssembly *)bestMatchFor:(TDAssembly *)a {
	NSSet *initialState = [NSSet setWithObject:a];
	NSSet *finalState = [self matchAndAssemble:initialState];
	return [self best:finalState];
}


- (TDAssembly *)completeMatchFor:(TDAssembly *)a {
	TDAssembly *best = [self bestMatchFor:a];
	if (best && ![best hasMore]) {
		return best;
	}
	return nil;
}


- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies {
	NSSet *outAssemblies = [self allMatchesFor:inAssemblies];
	if (assembler) {
	//if (assembler && [assembler respondsToSelector:selector]) {
		for (TDAssembly *a in outAssemblies) {
			[assembler performSelector:selector withObject:a];
		}
	}
	return outAssemblies;
}


- (TDAssembly *)best:(NSSet *)inAssemblies {
	TDAssembly *best = nil;
	
	for (TDAssembly *a in inAssemblies) {
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
	return [NSString stringWithFormat:@"%@ (%@)", [[self className] substringFromIndex:2], name];
}

@synthesize assembler;
@synthesize selector;
@synthesize name;
@end
