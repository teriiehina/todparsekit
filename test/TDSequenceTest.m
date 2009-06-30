//
//  TDSequenceTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSequenceTest.h"

@interface TDParser ()
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TDSequenceTest

- (void)tearDown {
}

- (void)testDiscard {
    s = @"foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo]foo/-^", [result description]);
}


- (void)testDiscard2 {
    s = @"foo foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, foo]foo/foo/-^", [result description]);
}


- (void)testDiscard3 {
    s = @"foo - foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, foo]foo/-/foo^", [result description]);
}


- (void)testDiscard1 {
    s = @"- foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo]-/foo^", [result description]);
}


- (void)testDiscard4 {
    s = @"- foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo]-/foo/-^", [result description]);
}


- (void)testDiscard5 {
    s = @"- foo + foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"+"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, foo]-/foo/+/foo^", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNil(result);
}


- (void)testFalseLiteralBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    TDNil(result);
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description]);
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDWord word]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description]);
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDNum num]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}


- (void)testTrueLiteralAllMatchsForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
}


- (void)testFalseLiteralAllMatchsForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"123"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    NSSet *result = [p allMatchesFor:[NSSet setWithObject:a]];
    
    TDNotNil(result);
    NSInteger c = result.count;
    TDEquals(0, c);
}

@end
