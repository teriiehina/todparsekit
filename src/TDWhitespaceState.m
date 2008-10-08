//
//  TDWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDWhitespaceState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>

@interface TDWhitespaceState () 
@property (nonatomic, retain) NSMutableArray *whitespaceChars;
@property (nonatomic, assign) NSNumber *yesFlag;
@property (nonatomic, assign) NSNumber *noFlag;
@end

@implementation TDWhitespaceState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.yesFlag = (id)kCFBooleanTrue;
		self.noFlag = (id)kCFBooleanFalse;
		
		self.whitespaceChars = [NSMutableArray array];
		NSInteger i = 0;
		for ( ; i < 256; i++) {
			[whitespaceChars addObject:noFlag];
		}
		
		[self setWhitespaceChars:YES from:0 to:' '];
	}
	return self;
}


- (void)dealloc {
	self.whitespaceChars = nil;
	self.yesFlag = nil;
	self.noFlag = nil;
	[super dealloc];
}


- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
	id obj = yn ? yesFlag : noFlag;
	NSInteger i = start;
	for ( ; i <= end; i++) {
		[whitespaceChars replaceObjectAtIndex:i withObject:obj];
	}
}


- (BOOL)isWhitespaceChar:(NSInteger)cin {
	if (-1 == cin || cin > whitespaceChars.count - 1) {
		return NO;
	}
	return yesFlag == [whitespaceChars objectAtIndex:cin];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	c = cin;
	while ([self isWhitespaceChar:c]) {
		c = [r read];
	}
	if (c != -1) {
		[r unread];
	}
	return [t nextToken];
}

@synthesize whitespaceChars;
@synthesize yesFlag;
@synthesize noFlag;
@end

