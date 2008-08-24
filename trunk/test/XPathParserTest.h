//
//  XPathParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <TDParseKit/TDParseKit.h>
#import "XPathParser.h"

@interface XPathParserTest : SenTestCase {
	NSString *s;
	XPathParser *p;
	TDAssembly *a;
	TDAssembly *result;
}

@end
