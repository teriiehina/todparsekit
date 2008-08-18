//
//  TODParseKitState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODTokenizerState.h>

@implementation TODTokenizerState

- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	NSAssert(0, @"TODTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
	return nil;
}

@end
