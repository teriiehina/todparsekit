//
//  TODJsonParserTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import <TODParseKit/TODParseKit.h>

@class TODJsonParser;

@interface TODJsonParserTest : SenTestCase {
	TODJsonParser *p;
	NSString *s;
	TODAssembly *a;
	TODAssembly *result;
}

@end
