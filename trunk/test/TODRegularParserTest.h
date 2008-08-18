//
//  TODRegularParserTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <TODParseKit/TODParseKit.h>
#import "TODRegularParser.h"

@interface TODRegularParserTest : SenTestCase {
	NSString *s;
	TODCharacterAssembly *a;
	TODRegularParser *p;
	TODAssembly *result;
}

@end
