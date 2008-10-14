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
@end

@implementation TDRepetition

+ (id)repetition {
	return [[[self alloc] initWithSubparser:nil] autorelease];
}


+ (id)repetitionWithSubparser:(TDParser *)p {
	return [[[self alloc] initWithSubparser:p] autorelease];
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


- (void)setPreassembler:(id)a selector:(SEL)sel {
	self.preAssembler = a;
	self.preAssemblerSelector = sel;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	if (preAssembler) {
	//if (preAssembler && [preAssembler respondsToSelector:preAssemblerSelector]) {
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
