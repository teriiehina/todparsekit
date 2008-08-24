//
//  TDRepetition.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDRepetition.h>
#import <TDParseKit/TDAssembly.h>

@interface TDParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@interface TDRepetition ()
@property (nonatomic, retain) TDParser *subparser;
@property (nonatomic, retain) id preAssembler;
@property (nonatomic, assign) SEL preAssemblerSelector;
@end

@implementation TDRepetition

+ (id)repetition {
	return [[[[self class] alloc] initWithSubparser:nil] autorelease];
}


+ (id)repetitionWithSubparser:(TDParser *)p {
	return [[[[self class] alloc] initWithSubparser:p] autorelease];
}


- (id)init {
	return [self initWithSubparser:nil];
}


- (id)initWithSubparser:(TDParser *)p {
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
		for (TDAssembly *a in inAssemblies) {
			[preAssembler performSelector:preAssemblerSelector withObject:a];
		}
	}
	
	NSMutableSet *outAssemblies = [NSMutableSet setWithSet:[[TDParser deepCopy:inAssemblies] autorelease]];
	
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
