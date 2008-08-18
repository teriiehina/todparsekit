//
//  TODSlashStarState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODSlashStarState.h"
#import "TODReader.h"
#import "TODTokenizer.h"
#import "TODToken.h"

@implementation TODSlashStarState

- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	NSInteger c;
	do {
		c = [r read];
		
		if ('*' == c) {
			char peek = [r read];
			if ('/' == peek) {
				c = [r read];
				break;
			} else {
				if (-1 != peek) {
					[r unread];
				}
			}
		}
	
	} while (-1 != c);

	if (-1 != c) {
		[r unread];
	}
	
	return [t nextToken];
}

@end
