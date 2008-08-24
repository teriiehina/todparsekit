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

@implementation TDWhitespaceState

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

@end
