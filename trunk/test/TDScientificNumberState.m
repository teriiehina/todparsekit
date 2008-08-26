//
//  TDScientificNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDScientificNumberState.h"
#import <TDParseKit/TDReader.h>

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
- (CGFloat)value;
@end

@implementation TDScientificNumberState

- (void)parseRightSideFromReader:(TDReader *)r {
	[super parseRightSideFromReader:r];
	if ('e' == c || 'E' == c) {
		NSInteger n = [r read];
		BOOL nextIsDigit = isdigit(n);
		if (-1 != n) {
			[r unread];
		}
		if (nextIsDigit) {
			[stringbuf appendFormat:@"%C", c];
			c = [r read];
			exp = [super absorbDigitsFromReader:r isFraction:NO];
		}
	}
}


- (void)reset:(NSInteger)cin {
	[super reset:cin];
	exp = 0.0f;
}


- (CGFloat)value {
	CGFloat result = floatValue;
	
	NSInteger i = 0;
	for ( ; i < exp; i++) {
		result *= 10.0f;
	}
	
	return (CGFloat)result;
}

@end
