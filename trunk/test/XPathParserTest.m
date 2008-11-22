//
//  XPathParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "XPathParserTest.h"
#import "TDNCName.h"

@implementation XPathParserTest

- (void)setUp {
    p = [[[XPathParser alloc] init] autorelease];
}

- (void)test {
    s = @"child::foo";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
//    NSLog(@"\n\n result: %@ \n\n", result);
    //STAssertEqualObjects(@"[/, foo]//foo^", [result description], @"");

    
    s = @"/foo";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    NSLog(@"\n\n result: %@ \n\n", result);
    STAssertEqualObjects(@"[/, foo]//foo^", [result description], @"");

    s = @"/foo/bar";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar]//foo///bar^", [result description], @"");
    
    s = @"/foo/bar/baz";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar, /, baz]//foo///bar///baz^", [result description], @"");
    
    s = @"/foo/bar[baz]";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar, [, baz, ]]//foo///bar/[/baz/]^", [result description], @"");
    
    s = @"/foo/bar[@baz]";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar, [, @, baz, ]]//foo///bar/[/@/baz/]^", [result description], @"");
    
    s = @"/foo/bar[@baz='foo']";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar, [, @, baz, =, 'foo', ]]//foo///bar/[/@/baz/=/'foo'/]^", [result description], @"");
    
    s = @"/foo/bar[baz]/foo";
    a = [p assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertEqualObjects(@"[/, foo, /, bar, [, baz, ], /, foo]//foo///bar/[/baz/]///foo^", [result description], @"");

    // not supported
//    s = @"//foo";
//    a = [p assemblyWithString:s];
//    result = [p bestMatchFor:a];
//    NSLog(@"\n\n result: %@ \n\n", result);
//    STAssertEqualObjects(@"[//, foo]///foo^", [result description], @"");
}


- (void)testAxisName {
    s = @"child";
    a = [p assemblyWithString:s];
    NSLog(@"\n\n a: %@ \n\n", a);
    result = [p.axisName bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[child]child^", [result description], @"");
    
    s = @"preceeding-sibling";
    a = [p assemblyWithString:s];
    result = [p.axisName bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[preceeding-sibling]preceeding-sibling^", [result description], @"");
}


- (void)testAxisSpecifier {
    s = @"child::";
    a = [p assemblyWithString:s];
    result = [p.axisSpecifier bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[child, ::]child/::^", [result description], @"");
    s = @"preceeding-sibling::";
    a = [p assemblyWithString:s];
    result = [p.axisSpecifier bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[preceeding-sibling, ::]preceeding-sibling/::^", [result description], @"");
}


- (void)testOperatorName {
    s = @"and";
    a = [p assemblyWithString:s];
    result = [p.operatorName bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[and]and^", [result description], @"");
    
    s = @"or";
    a = [p assemblyWithString:s];
    result = [p.operatorName bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[or]or^", [result description], @"");
}


- (void)testQName {
    s = @"foo:bar";
    a = [p assemblyWithString:s];
    result = [p.QName bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, :, bar]foo/:/bar^", [result description], @"");
    
    s = @"foo:bar";
    a = [p assemblyWithString:s];
    //STAssertThrowsSpecificNamed([p.QName bestMatchFor:a], [NSException class], @"TDTrackException", @"");
}


- (void)testNameTest {
    s = @"foo:bar";
    a = [p assemblyWithString:s];
    result = [p.nameTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, :, bar]foo/:/bar^", [result description], @"");

    s = @"*";
    a = [p assemblyWithString:s];
    result = [p.nameTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[*]*^", [result description], @"");

    s = @"foo:*";
    a = [p assemblyWithString:s];
    result = [p.nameTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, :, *]foo/:/*^", [result description], @"");
    
    s = @"*:bar"; // NOT ALLOWED
    a = [p assemblyWithString:s];
    result = [p.nameTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[*]*^:/bar", [result description], @"");
    
    s = @"foo";
    a = [p assemblyWithString:s];
    result = [p.nameTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo]foo^", [result description], @"");
    
    s = @"foo:bar";
    a = [p assemblyWithString:s];
    //STAssertThrowsSpecificNamed([p.nameTest bestMatchFor:a], [NSException class], @"TDTrackException", @"");
}


- (void)testNodeType {
    s = @"comment";
    a = [p assemblyWithString:s];
    result = [p.nodeType bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[comment]comment^", [result description], @"");
    
    s = @"node";
    a = [p assemblyWithString:s];
    result = [p.nodeType bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[node]node^", [result description], @"");
    
}


- (void)testNodeTest {
    s = @"comment()";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[comment, (, )]comment/(/)^", [result description], @"");

    s = @"processing-instruction()";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[processing-instruction, (, )]processing-instruction/(/)^", [result description], @"");
    
    s = @"processing-instruction('baz')";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[processing-instruction, (, 'baz', )]processing-instruction/(/'baz'/)^", [result description], @"");
    
    s = @"node()";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[node, (, )]node/(/)^", [result description], @"");

    s = @"text()";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[text, (, )]text/(/)^", [result description], @"");

    s = @"*";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[*]*^", [result description], @"");

    s = @"foo:*";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, :, *]foo/:/*^", [result description], @"");

    s = @"bar";
    a = [p assemblyWithString:s];
    result = [p.nodeTest bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[bar]bar^", [result description], @"");
}


- (void)testVariableReference {
    s = @"$foo";
    a = [p assemblyWithString:s];
    result = [p.variableReference bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[$, foo]$/foo^", [result description], @"");
    
    s = @"$bar";
    a = [p assemblyWithString:s];
    result = [p.variableReference bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[$, bar]$/bar^", [result description], @"");

    s = @"$foo:bar";
    a = [p assemblyWithString:s];
    result = [p.variableReference bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[$, foo, :, bar]$/foo/:/bar^", [result description], @"");
}


- (void)testFunctionCall {
    s = @"foo()";
    a = [p assemblyWithString:s];
    result = [p.functionCall bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, (, )]foo/(/)^", [result description], @"");

    s = @"foo('bar')";
    a = [p assemblyWithString:s];
    result = [p.functionCall bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, (, 'bar', )]foo/(/'bar'/)^", [result description], @"");

    s = @"foo('bar', 'baz')";
    a = [p assemblyWithString:s];
    result = [p.functionCall bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, (, 'bar', ,, 'baz', )]foo/(/'bar'/,/'baz'/)^", [result description], @"");

    s = @"foo('bar', 1)";
    a = [p assemblyWithString:s];
    result = [p.functionCall bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, (, 'bar', ,, 1, )]foo/(/'bar'/,/1/)^", [result description], @"");
}

- (void)testOrExpr {
    s = @"foo or bar";
    a = [p assemblyWithString:s];
    result = [p.orExpr bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, or, bar]foo/or/bar^", [result description], @"");
}


- (void)testAndExpr {
    s = @"foo() and bar()";
    a = [p assemblyWithString:s];
    result = [p.andExpr bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, (, ), and, bar, (, )]foo/(/)/and/bar/(/)^", [result description], @"");

    s = @"foo and bar";
    a = [p assemblyWithString:s];
    result = [p.andExpr bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foo, and, bar]foo/and/bar^", [result description], @"");
}

@end
