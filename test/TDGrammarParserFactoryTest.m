//
//  TDGrammarParserFactoryTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParserFactoryTest.h"
#import <TDParseKit/TDParseKit.h>
#import <OCMock/OCMock.h>

@interface TDGrammarParserFactory ()
- (TDSequence *)parserForExpression:(NSString *)s;
@property (retain) TDCollectionParser *expressionParser;
@end

@protocol TDMockAssember
- (void)workOnFooAssembly:(TDAssembly *)a;
- (void)workOnBazAssembly:(TDAssembly *)a;
- (void)workOnStart:(TDAssembly *)a;
- (void)workOnStartAssembly:(TDAssembly *)a;
- (void)workOn_StartAssembly:(TDAssembly *)a;
@end

@implementation TDGrammarParserFactoryTest

- (void)setUp {
    factory = [TDGrammarParserFactory factory];
    TDSequence *seq = [TDSequence sequence];
    [seq add:factory.expressionParser];
    exprSeq = seq;
}


- (void)testCSS2_1 {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css2_1" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path];
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
//    s = @"foo {font-size:12px}";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [lp bestMatchFor:a];
//    TDEqualObjects(@"[foo, {, font-family, :, 'helvetica', ;, }]foo/{/font-family/:/'helvetica'/;/}^", [res description]);
}    


- (void)testCSS {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path];
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"foo {font-family:'helvetica';}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'helvetica']foo/{/font-family/:/'helvetica'/;/}^", [res description]);
    
    s = @"foo {font-family:'helvetica'}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'helvetica']foo/{/font-family/:/'helvetica'/}^", [res description]);
    
    s = @"bar {color:rgb(1, 255, 255); font-style:italic;}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, {, color, (, 1, 255, 255, font-style, italic]bar/{/color/:/rgb/(/1/,/255/,/255/)/;/font-style/:/italic/;/}^", [res description]);
    
    s = @"bar {color:rgb(1, 255, 47.0); font-style:italic}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, {, color, (, 1, 255, 47.0, font-style, italic]bar/{/color/:/rgb/(/1/,/255/,/47.0/)/;/font-style/:/italic/}^", [res description]);
    
    s = @"foo {font-family:'Lucida Grande'} bar {color:rgb(1, 255, 255); font-style:italic;}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'Lucida Grande', bar, {, color, (, 1, 255, 255, font-style, italic]foo/{/font-family/:/'Lucida Grande'/}/bar/{/color/:/rgb/(/1/,/255/,/255/)/;/font-style/:/italic/;/}^", [res description]);
}


- (void)testJSON {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path];
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"{'foo':'bar'}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', :, 'bar', }]{/'foo'/:/'bar'/}^", [res description]);
    
    s = @"{'foo':{}}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', :, {, }, }]{/'foo'/:/{/}/}^", [res description]);
    
    s = @"{'foo':{'bar':[]}}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', :, {, 'bar', :, [, ], }, }]{/'foo'/:/{/'bar'/:/[/]/}/}^", [res description]);
    
    s = @"['foo', true, null]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, 'foo', ,, true, ,, null, ]][/'foo'/,/true/,/null/]^", [res description]);
    
    s = @"[[]]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, [, ], ]][/[/]/]^", [res description]);
    
    s = @"[[[1]]]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, [, [, 1, ], ], ]][/[/[/1/]/]/]^", [res description]);
}


- (void)testJSONWithDiscards {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json_with_discards" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path];
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"{'foo':'bar'}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', 'bar']{/'foo'/:/'bar'/}^", [res description]);
    
    s = @"{'foo':{}}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', {]{/'foo'/:/{/}/}^", [res description]);
    
    s = @"{'foo':{'bar':[]}}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', {, 'bar', []{/'foo'/:/{/'bar'/:/[/]/}/}^", [res description]);
    
    s = @"['foo', true, null]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, 'foo'][/'foo'/,/true/,/null/]^", [res description]);
    
    s = @"[[]]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, [][/[/]/]^", [res description]);
    
    s = @"[[[1]]]";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[[, [, [, 1][/[/[/1/]/]/]^", [res description]);
}


- (void)testStartLiteral {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = 'bar';";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testStartLiteralNonReserved {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo*; foo = 'bar';";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar, bar]bar/bar^", [res description]);
    [mock verify];
}


- (void)testStartLiteralNonReserved2 {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = (foo|baz)*; foo = 'bar'; baz = 'bat'";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    [[mock expect] workOnBazAssembly:OCMOCK_ANY];
    s = @"bar bat";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar, bat]bar/bat^", [res description]);
    [mock verify];
}


- (void)testStartLiteralNonReserved3 {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = (foo|baz)+; foo = 'bar'; baz = 'bat'";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    [[mock expect] workOnBazAssembly:OCMOCK_ANY];
    s = @"bar bat";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar, bat]bar/bat^", [res description]);
    [mock verify];
}


- (void)testStartLiteralNonReserved4 {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = (foo|baz)+; foo = 'bar'; baz = 'bat'";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    [[mock expect] workOnBazAssembly:OCMOCK_ANY];
    [[mock expect] workOnBazAssembly:OCMOCK_ANY];
    s = @"bar bat bat";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar, bat, bat]bar/bat/bat^", [res description]);
    [mock verify];
}


- (void)testStartLiteralWithCallback {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start (workOnStart:) = 'bar';";
    lp = [factory parserForGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOnStart:");

    [[mock expect] workOnStart:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testStartRefToLiteral {
    s = @" @start = foo; foo = 'bar';";
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
}


- (void)testStartRefToLiteral3 {
    s = @" @start = foo|baz; baz = 'bat'; foo = 'bar';";
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);

    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
}


- (void)testStartRefToLiteral2 {
    s = @"foo = 'bar'; baz = 'bat'; @start = (foo | baz)*;";
    lp = [factory parserForGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);

    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);

    s = @"bat bat";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bat, bat]bat/bat^", [res description]);

    s = @"bat bat bat bat bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bat, bat, bat, bat, bar]bat/bat/bat/bat/bar^", [res description]);
}


- (void)testStmtTrackException {
    s = @"@start = ";
    STAssertThrowsSpecificNamed([factory parserForGrammar:s assembler:nil], TDTrackException, TDTrackExceptionName, @"");

    s = @"@start";
    STAssertThrowsSpecificNamed([factory parserForGrammar:s assembler:nil], TDTrackException, TDTrackExceptionName, @"");
}


//- (void)testExprTrackException {
//    s = @"(foo";
//    STAssertThrowsSpecificNamed([factory parserForExpression:s], TDTrackException, TDTrackExceptionName, @"");
//
//    s = @"foo|";
//    STAssertThrowsSpecificNamed([factory parserForExpression:s], TDTrackException, TDTrackExceptionName, @"");
//}


- (void)testExprHelloPlus {
    s = @"'hello'+";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testExprHelloStar {
    s = @"'hello'*";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDRepetition class]);

    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[hello, hello, hello]hello/hello/hello^", [res description]);    
}


- (void)testExprHelloQuestion {
    s = @"'hello'?";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDAlternation class]);

    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello/hello", [res description]);    
}


- (void)testExprOhHaiThereQuestion {
    s = @"'oh'? 'hai'? 'there'?";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    s = @"there";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[there]there^", [res description]);    
}


- (void)testExprFooBar {
    s = @"'foo' 'bar'";
    a = [TDTokenAssembly assemblyWithString:s];

    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]'foo'/'bar'^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDLiteral *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, bar]foo/bar^", [res description]);
}


- (void)testExprFooBarBaz {
    s = @"'foo' 'bar' 'baz'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]'foo'/'bar'/'baz'^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)3, seq.subparsers.count);
    
    TDLiteral *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    c = [seq.subparsers objectAtIndex:2];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"baz", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [res description]);
}


- (void)testExprFooOrBar {
    s = @"'foo'|'bar'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'^", [res description]);

    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDAlternation class]);

    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);
}


- (void)testExprFooOrBarStar {
    s = @"'foo'|'bar'*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/*^", [res description]);

    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    TDRepetition *rep = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDLiteral *)rep.subparser;
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDAlternation class]]);

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, bar]bar/bar^", [res description]);
}


- (void)testExprFooOrBarPlus {
    s = @"'foo'|'bar'+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/+^", [res description]);

    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    TDSequence *seq = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDSequence class], [seq class]);
    
    c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDLiteral *)rep.subparser;
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDAlternation class]]);
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, bar, bar]bar/bar/bar^", [res description]);
}


- (void)testExprFooOrBarQuestion {
    s = @"'foo'|'bar'?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDAlternation class], [alt class]);
    
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([e isMemberOfClass:[TDEmpty class]]);
    
    c = (TDLiteral *)[alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDAlternation class]]);
    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar/bar", [res description]);
    
    s = @"foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar/bar", [res description]);
}


- (void)testExprParenFooOrBarParenStar {
    s = @"('foo'|'bar')*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Repetition](/'foo'/|/'bar'/)/*^", [res description]);
    TDRepetition *rep = [res pop];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    TDAlternation *alt = (TDAlternation *)rep.subparser;
    TDTrue([alt class] == [TDAlternation class]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDRepetition class]);
    s = @"foo bar bar foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, bar, foo]foo/bar/bar/foo^", [res description]);
}


- (void)testExprParenFooOrBooParenPlus {
    s = @"('foo'|'bar')+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence](/'foo'/|/'bar'/)/+^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDAlternation *alt = [seq.subparsers objectAtIndex:0];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    alt = (TDAlternation *)rep.subparser;
    TDEqualObjects([TDAlternation class], [alt class]);
    
    c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    s = @"foo foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, foo, bar, bar]foo/foo/bar/bar^", [res description]);
}


- (void)testExprParenFooOrBarParenQuestion {
    s = @"('foo'|'bar')?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation](/'foo'/|/'bar'/)/?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    
    TDEquals((NSUInteger)2, alt.subparsers.count);
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([TDEmpty class] == [e class]);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isKindOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDAlternation class]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar", [res description]);
}


- (void)testExprWord {
    s = @"Word";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Word]Word^", [res description]);
    TDWord *w = [res pop];
    TDTrue([w isMemberOfClass:[TDWord class]]);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDWord class]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello", [res description]);    
}


- (void)testExprWordPlus {
    s = @"Word+";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testExprNum {
    s = @"Num";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Num]Num^", [res description]);
    TDNum *w = [res pop];
    TDTrue([w isMemberOfClass:[TDNum class]]);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDNum class]]);
    
    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[333]333^444", [res description]);    
    
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDNil(res);
}


- (void)testExprNumCardinality {
    s = @"Num{2}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]Num/{/2/}^", [res description]);
    TDSequence *seq = [res pop];
    TDEqualObjects([seq class], [TDSequence class]);
    
    TDEquals((NSUInteger)2, seq.subparsers.count);
    TDNum *n = [seq.subparsers objectAtIndex:0];
    TDEqualObjects([n class], [TDNum class]);

    n = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([n class], [TDNum class]);

    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSequence class]]);
    
    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[333, 444]333/444^", [res description]);    
    
    s = @"1.1 2.2 3.3";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[1.1, 2.2]1.1/2.2^3.3", [res description]);    
    
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDNil(res);
}


- (void)testExprNumPlus {
    s = @"Num+";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[333, 444]333/444^", [res description]);    
}


- (void)testExprSymbol {
    s = @"Symbol";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Symbol]Symbol^", [res description]);
    TDSymbol *w = [res pop];
    TDTrue([w isMemberOfClass:[TDSymbol class]]);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDSymbol class]]);
    
    s = @"? #";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[?]?^#", [res description]);    
    
    s = @"hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDNil(res);
}


- (void)testExprSymbolPlus {
    s = @"Symbol+";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    s = @"% *";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[%, *]%/*^", [res description]);    
}


- (void)testExprQuotedString {
    s = @"QuotedString";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[QuotedString]QuotedString^", [res description]);
    TDQuotedString *w = [res pop];
    TDTrue([w isMemberOfClass:[TDQuotedString class]]);
    
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDQuotedString class]);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"['hello']'hello'^'hello'", [res description]);    
}


- (void)testExprQuotedStringPlus {
    s = @"QuotedString+";
    // use the result parser
    lp = [factory parserForExpression:s];
    TDNotNil(lp);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"['hello', 'hello']'hello'/'hello'^", [res description]);    
}

@end