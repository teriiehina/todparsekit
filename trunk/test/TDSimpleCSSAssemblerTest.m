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
    
    id props = [ass.properties objectForKey:@"foo"];
    TDNotNil(props);
    
    NSColor *color = [props objectForKey:@"background-color"];
    TDNotNil(color);
    STAssertEqualsWithAccuracy([color redComponent], (CGFloat)(255.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color greenComponent], (CGFloat)(0.0/255.0), 0.001, @"");
    STAssertEqualsWithAccuracy([color blueComponent], (CGFloat)(255.0/255.0), 0.001, @"");
}


- (void)testFontSize {
    TDNotNil(lp);
    
    s = @"decl { font-size:12px }";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [lp bestMatchFor:a];
    TDEqualObjects(@"[]decl/{/font-size/:/12/px/}^", [a description]);
    TDNotNil(ass.properties);
    
    id props = [ass.properties objectForKey:@"decl"];
    TDNotNil(props);
    
    NSNumber *size = [props objectForKey:@"font-size"];
    TDNotNil(size);
    TDEquals((CGFloat)[size doubleValue], (CGFloat)12.0);
    
    NSFont *font = [props objectForKey:@"font"];
    TDNotNil(font);
    TDEquals((CGFloat)[font pointSize], (CGFloat)12.0);
    TDEqualObjects([font familyName], @"Monaco");
}


- (void)testSmallFontSize {
    TDNotNil(lp);
    
    s = @"decl { font-size:8px }";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [lp bestMatchFor:a];
    TDEqualObjects(@"[]decl/{/font-size/:/8/px/}^", [a description]);
    TDNotNil(ass.properties);
    
    id props = [ass.properties objectForKey:@"decl"];
    TDNotNil(props);
    
    NSNumber *size = [props objectForKey:@"font-size"];
    TDNotNil(size);
    TDEquals((CGFloat)[size doubleValue], (CGFloat)8.0);
    
    NSFont *font = [props objectForKey:@"font"];
    TDNotNil(font);
    TDEquals((CGFloat)[font pointSize], (CGFloat)9.0);
    TDEqualObjects([font familyName], @"Monaco");
}


- (void)testFont {
    TDNotNil(lp);
    
    s = @"expr { font-size:16px; font-family:'Helvetica' }";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [lp bestMatchFor:a];
    TDEqualObjects(@"[]expr/{/font-size/:/16/px/;/font-family/:/'Helvetica'/}^", [a description]);
    TDNotNil(ass.properties);

    id props = [ass.properties objectForKey:@"expr"];
    TDNotNil(props);

    NSString *fontFamily = [props objectForKey:@"font-family"];
    TDNotNil(fontFamily);
    TDEqualObjects(fontFamily, @"Helvetica");
    
    NSNumber *size = [props objectForKey:@"font-size"];
    TDNotNil(size);
    TDEquals((CGFloat)[size doubleValue], (CGFloat)16.0);

    NSFont *font = [props objectForKey:@"font"];
    TDNotNil(font);
    TDEqualObjects([font familyName], @"Helvetica");
    TDEquals((CGFloat)[font pointSize], (CGFloat)16.0);
}


@end
