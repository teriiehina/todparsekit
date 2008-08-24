//
//  TDRegularParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDRegularParserTest.h"

@implementation TDRegularParserTest

- (void)test {
	s = @"1aa(2|3)*";
	p = [TDRegularParser parser];
	a = [TDCharacterAssembly assemblyWithString:s];
	result = [p completeMatchFor:a];
	NSLog(@"result: %@", result);
}

@end
