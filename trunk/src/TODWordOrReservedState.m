//
//  TODWordOrReservedState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODWordOrReservedState.h"

@interface TODWordOrReservedState ()
@property (nonatomic, retain) NSMutableSet *reservedWords;
@end

@implementation TODWordOrReservedState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.reservedWords = [NSMutableSet set];
	}
	return self;
}


- (void)dealloc {
	self.reservedWords = nil;
	[super dealloc];
}


- (void)addReservedWord:(NSString *)s {
	[reservedWords addObject:s];
}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	return nil;
}

@synthesize reservedWords;
@end
