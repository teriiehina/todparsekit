//
//  TDNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDNumberState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDSymbolState.h>

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)fraction;
- (void)parseLeftSideFromReader:(TDReader *)r;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
@end


@implementation TDNumberState

- (id)init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (void)dealloc {
	[super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	[self reset];
	negative = NO;
	char originalCin = cin;
	
	if ('-' == cin) {
		negative = YES;
		cin = [r read];
		[stringbuf appendString:@"-"];
	} else if ('+' == cin) {
		cin = [r read];
		[stringbuf appendString:@"+"];
	}
	
	[self reset:cin];
	if ('.' == c) {
		[stringbuf appendString:@"."];
		[self parseRightSideFromReader:r];
	} else {
		[self parseLeftSideFromReader:r];
		if ('.' == c) {
			[stringbuf appendString:@"."];
			[self parseRightSideFromReader:r];
		}
	}
	if (-1 != c) {
		[r unread];
	}
	
	// erroneous ., +, or -
	if (!gotADigit) {
		return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
	}
	
	if (negative) {
		floatValue = -floatValue;
	}
	
	return [[[TDToken alloc] initWithTokenType:TDTT_NUMBER 
									stringValue:[[stringbuf copy] autorelease] //[[NSNumber numberWithDouble:floatValue] stringValue]
									 floatValue:floatValue] autorelease];
}


- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)fraction {
	CGFloat divideBy = 1.0;
	CGFloat v = 0.0;
	
	while (1) {
		if ('0' <= c && c <= '9') {
			[stringbuf appendFormat:@"%C", c];
			gotADigit = YES;
			v = v * 10.0 + (c - '0');
			c = [r read];
			if (fraction) {
				divideBy *= 10.0;
			}
		} else {
			break;
		}
	}
	
	if (fraction) {
		v = v / divideBy;
	}

	return (CGFloat)v;
}


- (void)parseLeftSideFromReader:(TDReader *)r {
	floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}


- (void)parseRightSideFromReader:(TDReader *)r {
	c = [r read];
	floatValue += [self absorbDigitsFromReader:r isFraction:YES];
}


- (void)reset:(NSInteger)cin {
	gotADigit = NO;
	floatValue = 0.0;
	c = cin;
}

@end
