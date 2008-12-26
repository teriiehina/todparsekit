//
//  TDSimpleCSSAssemblerTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSimpleCSSAssemblerTest.h"

@implementation TDSimpleCSSAssemblerTest

- (void)setUp {
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css" ofType:@"grammar"];
    grammarString = [NSString stringWithContentsOfFile:path];
    ass = [[TDSimpleCSSAssembler alloc] init];
    factory = [TDGrammarParserFactory factory];
    lp = [factory parserForGrammar:grammarString assembler:ass];
}


- (void)tearDown {
    [ass release];
}


- (void)testColor {
    TDNotNil(lp);
    
    s = @"bar { color:rgb(10, 200, 30); }";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [lp bestMatchFor:a];
    TDEqualObjects(@"[]bar/{/color/:/rgb/(/10/,/200/,/30/)/;/}^", [a description]);
    TDNotNil(ass.properties);
    id barProps = [ass.properties objectForKey:@"bar"];
    TDNotNil(barProps);
    NSColor *color = [barProps objectForKey:@"color"];
    TDNotNil(color);
    STAssertEqualsWithAccuracy([color redComponent], (CGFloat)(10.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color greenComponent], (CGFloat)(200.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color blueComponent], (CGFloat)(30.0/255.0), 0.001, @"");
}


- (void)testBackgroundColor {
    TDNotNil(lp);
    
    s = @"foo { background-color:rgb(255.0, 0.0, 255.0) }";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [lp bestMatchFor:a];
    TDEqualObjects(@"[]foo/{/background-color/:/rgb/(/255.0/,/0.0/,/255.0/)/}^", [a description]);
    TDNotNil(ass.properties);
    id fooProps = [ass.properties objectForKey:@"foo"];
    TDNotNil(fooProps);
    NSColor *color = [fooProps objectForKey:@"background-color"];
    TDNotNil(color);
    STAssertEqualsWithAccuracy([color redComponent], (CGFloat)(255.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color greenComponent], (CGFloat)(0.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color blueComponent], (CGFloat)(255.0/255.0), 0.001, @"");
}



@end
