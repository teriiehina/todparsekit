//
//  TODSignificantWhitespaceState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODSignificantWhitespaceState.h>
#import <TODParseKit/TODReader.h>
#import <TODParseKit/TODTokenizer.h>
#import <TODParseKit/TODToken.h>

@interface TODSignificantWhitespaceState () 
@property (nonatomic, retain) NSMutableArray *whitespaceChars;
@property (nonatomic, retain) NSNumber *yesFlag;
@property (nonatomic, retain) NSNumber *noFlag;
@end

@implementation TODSignificantWhitespaceState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.yesFlag = [NSNumber numberWithBool:YES];
		self.noFlag = [NSNumber numberWithBool:NO];
		
		self.whitespaceChars = [NSMutableArray array];
		NSInteger i = 0;
		for ( ; i < 256; i++) {
			[whitespaceChars addObject:noFlag];
		}
		
		[self setWhitespaceChars:YES from: 0 to: ' '];
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
	NSInteger i = 0;
	for (i = start; i <= end; i++) {
		[whitespaceChars replaceObjectAtIndex:i withObject:obj];
	}
}


- (BOOL)isWhitespaceChar:(NSInteger)cin {
	if (-1 == cin || cin > whitespaceChars.count - 1) {
		return NO;
	}
	return yesFlag == [whitespaceChars objectAtIndex:cin];
}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	[self reset];
	
	c = cin;
	while ([self isWhitespaceChar:c]) {
		[stringbuf appendFormat:@"%C", c];
		c = [r read];
	}
	if (c != -1) {
		[r unread];
	}
	
	return [[[TODToken alloc] initWithTokenType:TODTT_WHITESPACE 
									stringValue:[[stringbuf copy] autorelease]
									 floatValue:0.0f] autorelease];
}


@synthesize whitespaceChars;
@synthesize yesFlag;
@synthesize noFlag;
@end
