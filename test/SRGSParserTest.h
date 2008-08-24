//
//  SRGSParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <TDParseKit/TDParseKit.h>
#import "SRGSParser.h"

@interface SRGSParserTest : SenTestCase {
	NSString *s;
	SRGSParser *p;
	TDAssembly *a;
	TDAssembly *result;
}

@end
