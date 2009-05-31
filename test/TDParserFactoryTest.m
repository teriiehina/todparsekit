//
//  TDParserFactoryTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDParserFactoryTest.h"
#import <OCMock/OCMock.h>

@interface TDParserFactory ()
- (TDSequence *)parserFromExpression:(NSString *)s;
@property (retain) TDCollectionParser *expressionParser;
@end

@protocol TDMockAssember
- (void)workOnFooAssembly:(TDAssembly *)a;
- (void)workOnBazAssembly:(TDAssembly *)a;
- (void)workOnStart:(TDAssembly *)a;
- (void)workOnStartAssembly:(TDAssembly *)a;
- (void)workOn_StartAssembly:(TDAssembly *)a;
@end

@implementation TDParserFactoryTest

- (void)setUp {
    factory = [TDParserFactory factory];
    TDSequence *seq = [TDSequence sequence];
    [seq add:factory.expressionParser];
    exprSeq = seq;
}


- (void)testJavaScript {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"javascript" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"var foo = 'bar';";
    lp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:lp.tokenizer];
//    res = [lp bestMatchFor:a];
//    TDEqualObjects(@"[var, foo, =, 'bar', ;]var/foo/=/bar/;^", [res description]);
}


- (void)testCSS2_1 {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css2_1" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
//    s = @"foo {font-size:12px}";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [lp bestMatchFor:a];
//    TDEqualObjects(@"[foo, {, font-family, :, 'helvetica', ;, }]foo/{/font-family/:/'helvetica'/;/}^", [res description]);
}    


- (void)testCSS {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mini_css" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    TDParser *selectorParser = [lp parserNamed:@"selector"];
    TDNotNil(selectorParser);
    TDEqualObjects(selectorParser.name, @"selector");
    TDEqualObjects([selectorParser class], [TDLowercaseWord class]);

    TDParser *declParser = [lp parserNamed:@"decl"];
    TDNotNil(declParser);
    TDEqualObjects(declParser.name, @"decl");
    TDEqualObjects([declParser class], [TDSequence class]);

    TDParser *rulesetParser = [lp parserNamed:@"ruleset"];
    TDNotNil(rulesetParser);
    TDEqualObjects(rulesetParser, [(TDRepetition *)lp subparser]);
    TDEqualObjects(rulesetParser.name, @"ruleset");
    TDEqualObjects([rulesetParser class], [TDSequence class]);
    
    TDParser *startParser = [lp parserNamed:@"@start"];
    TDNotNil(startParser);
    TDEqualObjects(startParser, lp);
    TDEqualObjects(startParser.name, @"@start");
    TDEqualObjects([startParser class], [TDRepetition class]);
    
    s = @"foo {font-family:'helvetica';}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'helvetica']foo/{/font-family/:/'helvetica'/;/}^", [res description]);
    
    s = @"foo {font-family:'helvetica'}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'helvetica']foo/{/font-family/:/'helvetica'/}^", [res description]);
    
    s = @"bar {color:rgb(1, 255, 255); font-size:13px;}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, {, color, (, 1, 255, 255, font-size, 13]bar/{/color/:/rgb/(/1/,/255/,/255/)/;/font-size/:/13/px/;/}^", [res description]);
    
    s = @"bar {color:rgb(1, 255, 47.0); font-family:'Helvetica'}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar, {, color, (, 1, 255, 47.0, font-family, 'Helvetica']bar/{/color/:/rgb/(/1/,/255/,/47.0/)/;/font-family/:/'Helvetica'/}^", [res description]);
    
    s = @"foo {font-family:'Lucida Grande'} bar {color:rgb(1, 255, 255); font-size:9px;}";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[foo, {, font-family, 'Lucida Grande', bar, {, color, (, 1, 255, 255, font-size, 9]foo/{/font-family/:/'Lucida Grande'/}/bar/{/color/:/rgb/(/1/,/255/,/255/)/;/font-size/:/9/px/;/}^", [res description]);
}


- (void)testJSON {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
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
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
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
    lp = [factory parserFromGrammar:s assembler:mock];
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
    lp = [factory parserFromGrammar:s assembler:mock];
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
    lp = [factory parserFromGrammar:s assembler:mock];
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
    lp = [factory parserFromGrammar:s assembler:mock];
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
    lp = [factory parserFromGrammar:s assembler:mock];
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


- (void)testAssemblerSettingBehaviorDefault {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo|baz; foo = 'bar'; baz = 'bat'";
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testAssemblerSettingBehaviorOnAll {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo|baz; foo = 'bar'; baz = 'bat'";
    factory.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnAll;
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDTrue(lp.assembler == mock);
    TDEqualObjects(NSStringFromSelector(lp.selector), @"workOn_StartAssembly:");
    
    [[mock expect] workOn_StartAssembly:OCMOCK_ANY];
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testAssemblerSettingBehaviorOnTerminals {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo|baz; foo = 'bar'; baz = 'bat'";
    factory.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnTerminals;
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDNil(lp.assembler);
    TDNil(NSStringFromSelector(lp.selector));
    
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testAssemblerSettingBehaviorOnExplicit {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo|baz; foo (workOnFooAssembly:) = 'bar'; baz (workOnBazAssembly:) = 'bat'";
    factory.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnExplicit;
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDNil(lp.assembler);
    TDNil(NSStringFromSelector(lp.selector));
    
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testAssemblerSettingBehaviorOnExplicitNone {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = foo|baz; foo = 'bar'; baz = 'bat'";
    factory.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnExplicit;
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDNil(lp.assembler);
    TDNil(NSStringFromSelector(lp.selector));
    
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    [mock verify];
}


- (void)testAssemblerSettingBehaviorOnExplicitOrTerminal {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start = (foo|baz)+; foo (workOnFooAssembly:) = 'bar'; baz = 'bat'";
    factory.assemblerSettingBehavior = (TDParserFactoryAssemblerSettingBehaviorOnExplicit | TDParserFactoryAssemblerSettingBehaviorOnTerminals);
    lp = [factory parserFromGrammar:s assembler:mock];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    TDEqualObjects(lp.name, @"@start");
    TDNil(lp.assembler);
    TDNil(NSStringFromSelector(lp.selector));
    
    [[mock expect] workOnFooAssembly:OCMOCK_ANY];
    [[mock expect] workOnBazAssembly:OCMOCK_ANY];
    s = @"bar bat";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp completeMatchFor:a];
    TDEqualObjects(@"[bar, bat]bar/bat^", [res description]);
    [mock verify];
}


- (void)testStartLiteralWithCallback {
    id mock = [OCMockObject mockForProtocol:@protocol(TDMockAssember)];
    s = @"@start (workOnStart:) = 'bar';";
    lp = [factory parserFromGrammar:s assembler:mock];
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
    lp = [factory parserFromGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
}


- (void)testStartRefToLiteral3 {
    s = @" @start = foo|baz; baz = 'bat'; foo = 'bar';";
    lp = [factory parserFromGrammar:s assembler:nil];
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);

    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
}


- (void)testStartRefToLiteral2 {
    s = @"foo = 'bar'; baz = 'bat'; @start = (foo | baz)*;";
    lp = [factory parserFromGrammar:s assembler:nil];
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
    STAssertThrowsSpecificNamed([factory parserFromGrammar:s assembler:nil], TDTrackException, TDTrackExceptionName, @"");

    s = @"@start";
    STAssertThrowsSpecificNamed([factory parserFromGrammar:s assembler:nil], TDTrackException, TDTrackExceptionName, @"");
}


//- (void)testExprTrackException {
//    s = @"(foo";
//    STAssertThrowsSpecificNamed([factory parserFromExpression:s], TDTrackException, TDTrackExceptionName, @"");
//
//    s = @"foo|";
//    STAssertThrowsSpecificNamed([factory parserFromExpression:s], TDTrackException, TDTrackExceptionName, @"");
//}


- (void)testExprHelloPlus {
    s = @"'hello'+";
    // use the result parser
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
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
    lp = [factory parserFromExpression:s];
    TDNotNil(lp);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"['hello', 'hello']'hello'/'hello'^", [res description]);
}


- (void)testRubyHash {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"rubyhash" ofType:@"grammar"];
    s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    lp = [factory parserFromGrammar:s assembler:nil];
    
    TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
  
//    s = @"{\"brand\"=>{\"name\"=>\"something\","
//    @"\"logo\"=>#<File:/var/folders/RK/RK1vsZigGhijmL6ObznDJk+++TI/-Tmp-/CGI66145-4>,"
//    @"\"summary\"=>\"wee\", \"content\"=>\"woopy doo\"}, \"commit\"=>\"Save\","
//    @"\"authenticity_token\"=>\"43a94d60304a7fb13a4ff61a5960461ce714e92b\","
//    @"\"action\"=>\"create\", \"controller\"=>\"admin/brands\"}";

    lp.tokenizer.string = @"{'foo'=> {'logo' => #<File:/var/folders/RK/RK1vsZigGhijmL6ObznDJk+++TI/-Tmp-/CGI66145-4> } }";
    
    a = [TDTokenAssembly assemblyWithTokenizer:lp.tokenizer];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[{, 'foo', =>, {, 'logo', =>, #<File:/var/folders/RK/RK1vsZigGhijmL6ObznDJk+++TI/-Tmp-/CGI66145-4>, }, }]{/'foo'/=>/{/'logo'/=>/#<File:/var/folders/RK/RK1vsZigGhijmL6ObznDJk+++TI/-Tmp-/CGI66145-4>/}/}^", [res description]);
}


- (void)testSymbolState {
	s = @"@symbolState = 'b'; @start = ('b'|'ar')*;";
	lp = [factory parserFromGrammar:s assembler:nil];
	
	TDNotNil(lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);

	lp.tokenizer.string = @"bar";
    a = [TDTokenAssembly assemblyWithTokenizer:lp.tokenizer];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[b, ar]b/ar^", [res description]);
	[res pop]; // discar 'ar'
	TDToken *tok = [res pop];
	TDEqualObjects([tok class], [TDToken class]);
	TDEqualObjects(tok.stringValue, @"b");
	TDTrue(tok.isSymbol);
}

@end