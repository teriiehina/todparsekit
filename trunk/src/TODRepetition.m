//
//  TODRepetition.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODRepetition.h>
#import <TODParseKit/TODAssembly.h>

@interface TODParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@interface TODRepetition ()
@property (nonatomic, retain) TODParser *subparser;
@property (nonatomic, retain) id preAssembler;
@property (nonatomic, assign) SEL preAssemblerSelector;
@end

@implementation TODRepetition

+ (id)repetition {
	return [[[[self class] alloc] initWithSubparser:nil] autorelease];
}


+ (id)repetitionWithSubparser:(TODParser *)p {
	return [[[[self class] alloc] initWithSubparser:p] autorelease];
}


- (id)init {
	return [self initWithSubparser:nil];
}


- (id)initWithSubparser:(TODParser *)p {
	self = [super init];
	if (self != nil) {
		self.subparser = p;
	}
	return self;
}


- (void)dealloc {
	self.subparser = nil;
	self.preAssembler = nil;
	self.preAssemblerSelector = nil;
	[super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	if (preAssembler && [preAssembler respondsToSelector:preAssemblerSelector]) {
		for (TODAssembly *a in inAssemblies) {
			[preAssembler performSelector:preAssemblerSelector withObject:a];
		}
	}
	
	NSMutableSet *outAssemblies = [NSMutableSet setWithSet:[[TODParser deepCopy:inAssemblies] autorelease]];
	
	NSSet *s = inAssemblies;
	while (s.count) {
		s = [subparser matchAndAssemble:s];
		[outAssemblies unionSet:s];
	}
	
	return outAssemblies;
}

@synthesize subparser;
@synthesize preAssembler;
@synthesize preAssemblerSelector;
@end
