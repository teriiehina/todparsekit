//
//  TDFastJsonParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDFastJsonParserTest.h"
#import "TDFastJsonParser.h"

@implementation TDFastJsonParserTest

- (void)testRun {
    NSString *s = @"{\"foo\":\"bar\"}";
    TDFastJsonParser *p = [[[TDFastJsonParser alloc] init] autorelease];
    id result = [p parse:s];
    
    NSLog(@"result");
    TDNotNil(result);
}

@end
