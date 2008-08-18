//
//  TODWhitespaceState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODWhitespaceState.h>
#import <TODParseKit/TODReader.h>
#import <TODParseKit/TODTokenizer.h>

@implementation TODWhitespaceState

- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
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
