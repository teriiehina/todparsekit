//
//  XPathParserGrammarTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/28/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPathParserGrammarTest.h"

@implementation XPathParserGrammarTest

- (void)setUp {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xpath1_0" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path];
    p = [[TDParserFactory factory] parserFromGrammar:g assembler:nil];
    t = p.tokenizer;
}


//- (void)testFoo {
//    t.string = @"foo";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo]foo^", [res description]);
//}


- (void)test {
    t.string = @"child::foo";
    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    //    NSLog(@"\n\n res: %@ \n\n", res);
    //TDEqualObjects(@"[/, foo]//foo^", [res description]);
    
    
    t.string = @"/foo";
    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    NSLog(@"\n\n res: %@ \n\n", res);
    TDEqualObjects(@"[/, foo]//foo^", [res description]);
    
//    t.string = @"/foo/bar";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar]//foo///bar^", [res description]);
//    
//    t.string = @"/foo/bar/baz";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar, /, baz]//foo///bar///baz^", [res description]);
//    
//    t.string = @"/foo/bar[baz]";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar, [, baz, ]]//foo///bar/[/baz/]^", [res description]);
//    
//    t.string = @"/foo/bar[@baz]";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar, [, @, baz, ]]//foo///bar/[/@/baz/]^", [res description]);
//    
//    t.string = @"/foo/bar[@baz='foo']";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar, [, @, baz, =, 'foo', ]]//foo///bar/[/@/baz/=/'foo'/]^", [res description]);
//    
//    t.string = @"/foo/bar[baz]/foo";
//    res = [p completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[/, foo, /, bar, [, baz, ], /, foo]//foo///bar/[/baz/]///foo^", [res description]);
//    
//    // not supported
//    //    t.string = @"//foo";
//    //    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    //    res = [p bestMatchFor:a];
//    //    NSLog(@"\n\n res: %@ \n\n", res);
//    //    TDEqualObjects(@"[//, foo]///foo^", [res description]);
}


//- (void)testAxisName {
//    t.string = @"child";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    NSLog(@"\n\n a: %@ \n\n", a);
//    res = [[p parserNamed:@"axisName"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[child]child^", [res description]);
    
//    t.string = @"preceeding-sibling";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"axisName"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[preceeding-sibling]preceeding-sibling^", [res description]);
//}


//- (void)testAxisSpecifier {
//    t.string = @"child::";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"axisSpecifier"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[child, ::]child/::^", [res description]);
//    t.string = @"preceeding-sibling::";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"axisSpecifier"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[preceeding-sibling, ::]preceeding-sibling/::^", [res description]);
//}


//- (void)testOperatorName {
//    t.string = @"and";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"operatorName"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[and]and^", [res description]);
//    
//    t.string = @"or";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"operatorName"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[or]or^", [res description]);
//}
//
//
//- (void)testQName {
//    t.string = @"foo:bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"QName"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, :, bar]foo/:/bar^", [res description]);
//    
//    t.string = @"foo:bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    //TDAssertThrowsSpecificNamed([p.QName bestMatchFor:a], [NSException class], @"TDTrackException");
//}

//
//- (void)testNameTest {
//    t.string = @"foo:bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nameTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, :, bar]foo/:/bar^", [res description]);
//    
//    t.string = @"*";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nameTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[*]*^", [res description]);
//    
//    t.string = @"foo:*";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nameTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, :, *]foo/:/*^", [res description]);
//    
//    t.string = @"*:bar"; // NOT ALLOWED
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nameTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[*]*^:/bar", [res description]);
//    
//    t.string = @"foo";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nameTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo]foo^", [res description]);
//    
//    t.string = @"foo:bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    //TDAssertThrowsSpecificNamed([p.nameTest bestMatchFor:a], [NSException class], @"TDTrackException");
//}
//
//
//- (void)testNodeType {
//    t.string = @"comment";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeType"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[comment]comment^", [res description]);
//    
//    t.string = @"node";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeType"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[node]node^", [res description]);
//    
//}
//
//
//- (void)testNodeTest {
//    t.string = @"comment()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[comment, (, )]comment/(/)^", [res description]);
//    
//    t.string = @"processing-instruction()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[processing-instruction, (, )]processing-instruction/(/)^", [res description]);
//    
//    t.string = @"processing-instruction('baz')";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[processing-instruction, (, 'baz', )]processing-instruction/(/'baz'/)^", [res description]);
//    
//    t.string = @"node()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[node, (, )]node/(/)^", [res description]);
//    
//    t.string = @"text()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[text, (, )]text/(/)^", [res description]);
//    
//    t.string = @"*";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[*]*^", [res description]);
//    
//    t.string = @"foo:*";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, :, *]foo/:/*^", [res description]);
//    
//    t.string = @"bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"nodeTest"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[bar]bar^", [res description]);
//}
//
//
//- (void)testVariableReference {
//    t.string = @"$foo";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"variableReference"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[$, foo]$/foo^", [res description]);
//    
//    t.string = @"$bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"variableReference"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[$, bar]$/bar^", [res description]);
//    
//    t.string = @"$foo:bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"variableReference"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[$, foo, :, bar]$/foo/:/bar^", [res description]);
//}
//
//
//- (void)testFunctionCall {
//    t.string = @"foo()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"functionCall"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, (, )]foo/(/)^", [res description]);
//    
//    t.string = @"foo('bar')";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"functionCall"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, (, 'bar', )]foo/(/'bar'/)^", [res description]);
//    
//    t.string = @"foo('bar', 'baz')";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"functionCall"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, (, 'bar', ,, 'baz', )]foo/(/'bar'/,/'baz'/)^", [res description]);
//    
//    t.string = @"foo('bar', 1)";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"functionCall"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, (, 'bar', ,, 1, )]foo/(/'bar'/,/1/)^", [res description]);
//}
//
//- (void)testOrExpr {
//    t.string = @"foo or bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"orExpr"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, or, bar]foo/or/bar^", [res description]);
//}
//
//
//- (void)testAndExpr {
//    t.string = @"foo() and bar()";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"andExpr"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, (, ), and, bar, (, )]foo/(/)/and/bar/(/)^", [res description]);
//    
//    t.string = @"foo and bar";
//    a = [TDTokenAssembly assemblyWithTokenizer:t];
//    res = [[p parserNamed:@"andExpr"] bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[foo, and, bar]foo/and/bar^", [res description]);
//}

@end
