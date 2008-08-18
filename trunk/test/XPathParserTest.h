//
//  XPathParserTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <TODParseKit/TODParseKit.h>
#import "XPathParser.h"

@interface XPathParserTest : SenTestCase {
	NSString *s;
	XPathParser *p;
	TODAssembly *a;
	TODAssembly *result;
}

@end
