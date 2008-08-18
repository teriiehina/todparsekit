//
//  TODSlashState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODSlashState.h>
#import <TODParseKit/TODReader.h>
#import <TODParseKit/TODTokenizer.h>
#import <TODParseKit/TODToken.h>
#import <TODParseKit/TODSlashSlashState.h>
#import <TODParseKit/TODSlashStarState.h>

@interface TODSlashState ()
@property (nonatomic, retain) TODSlashSlashState *slashSlashState;
@property (nonatomic, retain) TODSlashStarState *slashStarState;
@end

@implementation TODSlashState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.slashSlashState = [[[TODSlashSlashState alloc] init] autorelease];
		self.slashStarState  = [[[TODSlashStarState alloc] init] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.slashSlashState = nil;
	self.slashStarState = nil;
	[super dealloc];
}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	NSInteger c = [r read];
//	NSLog(@"c: %c", c);
	if ('/' == c) {
		return [slashSlashState nextTokenFromReader:r startingWith:c tokenizer:t];
	} else if ('*' == c) {
		return [slashStarState nextTokenFromReader:r startingWith:c tokenizer:t];
	} else {
		// TODO symbol
		if (-1 != c) {
			[r unread];
		}
		return [[[TODToken alloc] initWithTokenType:TODTT_SYMBOL stringValue:@"/" floatValue:0.0f] autorelease];
	}
}

@synthesize slashSlashState;
@synthesize slashStarState;
@end
