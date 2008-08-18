//
//  TODTerminal.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTerminal.h"
#import "TODAssembly.h"
#import "TODToken.h"

@interface TODTerminal ()
- (TODAssembly *)matchOneAssembly:(TODAssembly *)inAssembly;
- (BOOL)qualifies:(id)obj;

@property (nonatomic, readwrite, copy) NSString *string;
@end

@implementation TODTerminal

+ (id)terminal {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)terminalWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)init {
	return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
	self = [super init];
	if (self != nil) {
		self.string = s;
	}
	return self;
}


- (void)dealloc {
	self.string = nil;
	[super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	NSMutableSet *outAssemblies = [NSMutableSet set];
	
	for (TODAssembly *a in inAssemblies) {
		TODAssembly *b = [self matchOneAssembly:a];
		if (b) {
			[outAssemblies addObject:b];
		}
	}
	
	return outAssemblies;
}


- (TODAssembly *)matchOneAssembly:(TODAssembly *)inAssembly {
	if (![inAssembly hasMore]) {
		return nil;
	}
	
	TODAssembly *outAssembly = nil;
	
	if ([self qualifies:[inAssembly peek]]) {
		outAssembly = [[inAssembly copy] autorelease];
		id obj = [outAssembly next];
		if (!discard) {
			[outAssembly push:obj];
		}
	}
	
	return outAssembly;
}


- (BOOL)qualifies:(id)obj {
	NSAssert1(0, @"-[TODTerminal %s] must be overriden", _cmd);
	return NO;
}


- (TODTerminal *)discard {
	discard = YES;
	return self;
}

@synthesize string;
@end
