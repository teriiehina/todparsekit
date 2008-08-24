//
//  TDParseKitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizerState.h>

@implementation TDTokenizerState

- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
	return nil;
}

@end
