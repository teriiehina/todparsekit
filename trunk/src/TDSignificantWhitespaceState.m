//
//  TDSignificantWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSignificantWhitespaceState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@implementation TDSignificantWhitespaceState

- (void)dealloc {
	[super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	[self reset];
	
	c = cin;
	while ([self isWhitespaceChar:c]) {
		[stringbuf appendFormat:@"%C", c];
		c = [r read];
	}
	if (c != -1) {
		[r unread];
	}
	
	return [TDToken tokenWithTokenType:TDTT_WHITESPACE 
						   stringValue:[[stringbuf copy] autorelease]
							floatValue:0.0f];
}

@end
