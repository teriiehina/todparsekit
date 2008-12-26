//
//  TDGenericAssemblerTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDGenericAssemblerTest.h"

@implementation TDGenericAssemblerTest

- (void)setUp {
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css" ofType:@"grammar"];
    grammarString = [NSString stringWithContentsOfFile:path];
    cssAssember = [[TDSimpleCSSAssembler alloc] init];
    factory = [TDGrammarParserFactory factory];
    cssParser = [factory parserForGrammar:grammarString assembler:cssAssember];
}


- (void)tearDown {
    [cssAssember release];
}


- (void)testColor {
    TDNotNil(cssParser);
    
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"css"];
    s = [NSString stringWithContentsOfFile:path];
    a = [TDTokenAssembly assemblyWithString:s];
    a = [cssParser bestMatchFor:a];
    
    TDNotNil(cssAssember.attributes);
    id props = [cssAssember.attributes objectForKey:@"openCurly"];
    TDNotNil(props);

//    color:red;
//    background-color:blue;
//    font-family:'Helvetica';
//    font-size:17px;
    
    NSFont *font = [props objectForKey:NSFontAttributeName];
    TDNotNil(font);
    TDEqualObjects([font familyName], @"Helvetica");
    TDEquals((CGFloat)[font pointSize], (CGFloat)17.0);
    
    NSColor *bgColor = [props objectForKey:NSBackgroundColorAttributeName];
    TDNotNil(bgColor);
    STAssertEqualsWithAccuracy([bgColor redComponent], (CGFloat)0.0, 0.001, @"");
    STAssertEqualsWithAccuracy([bgColor greenComponent], (CGFloat)0.0, 0.001, @"");
    STAssertEqualsWithAccuracy([bgColor blueComponent], (CGFloat)1.0, 0.001, @"");
    
    NSColor *color = [props objectForKey:NSForegroundColorAttributeName];
    TDNotNil(color);
    STAssertEqualsWithAccuracy([color redComponent], (CGFloat)1.0, 0.001, @"");
    STAssertEqualsWithAccuracy([color greenComponent], (CGFloat)0.0, 0.001, @"");
    STAssertEqualsWithAccuracy([color blueComponent], (CGFloat)0.0, 0.001, @"");
    
}




@end
