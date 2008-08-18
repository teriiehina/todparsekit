//
//  TODRegularParserTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODRegularParserTest.h"

@implementation TODRegularParserTest

- (void)test {
	s = @"1aa(2|3)*";
	p = [TODRegularParser parser];
	a = [TODCharacterAssembly assemblyWithString:s];
	result = [p completeMatchFor:a];
	NSLog(@"result: %@", result);
}

@end
