//
//  TDPatternTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDPatternTest.h"

@implementation TDPatternTest

- (void)testFoo {
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo"];

    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDWord word]];

    a = [inter completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
        
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo"];

    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDSymbol symbol]];

    a = [inter completeMatchFor:a];
    
    TDNil(a);
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo+"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo*"];
    a = [p completeMatchFor:a];

    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo{1,2}"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo{3,4}"];
    a = [p completeMatchFor:a];
    
    TDNil(a);
}


- (void)testSlashFooSlash {
    s = @"/foo/";

    t = [TDTokenizer tokenizerWithString:s];
    [t setTokenizerState:t.quoteState from:'/' to:'/'];
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    p = [TDPattern patternWithString:@"/foo/" options:TDPatternOptionsNone];
    
    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDQuotedString quotedString]];

    a = [inter completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[/foo/]/foo/^");

    t = [TDTokenizer tokenizerWithString:s];
    [t setTokenizerState:t.quoteState from:'/' to:'/'];
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    p = [TDPattern patternWithString:@"/[^/]+/" options:TDPatternOptionsNone];

    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDQuotedString quotedString]];
    
    a = [inter completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[/foo/]/foo/^");
}


- (void)testAndOrOr {
    s = @"and";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[and]and^");
    
    s = @"and";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"an|or"];
    a = [p completeMatchFor:a];
    
    TDNil(a);
    
    s = @"or";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"(and)|(or)"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[or]or^");
}    


- (void)testNotAnd {
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"[^and]+"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    s = @"and";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"[^(and)]"];
    a = [p completeMatchFor:a];
    
    TDNil(a);
}    


- (void)testInvertFoo {
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo+"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    p = [p invertedPattern];
    a = [p completeMatchFor:a];
    
    TDNil(a);
}    


- (void)testInvertAndOrNotTrueFalse {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or|not|true|false"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[true]true^");
    
    p = [p invertedPattern];
    a = [p completeMatchFor:a];
    
    TDNil(a);

    s = @"TRUE";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or|not|true|false" options:TDPatternOptionsIgnoreCase];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[TRUE]TRUE^");
    
    p = [p invertedPattern];
    a = [p completeMatchFor:a];
    
    TDNil(a);

    s = @"NOT";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or|not|true|false" options:TDPatternOptionsIgnoreCase];

    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDWord word]];
    
    a = [inter completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[NOT]NOT^");
    
    p = [p invertedPattern];
    a = [p completeMatchFor:a];
    
    TDNil(a);

    s = @"oR";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or|not|true|false" options:TDPatternOptionsIgnoreCase];
    
    inter = [PKIntersection intersection];
    [inter add:p];
    [inter add:[TDSymbol symbol]];
    
    a = [inter completeMatchFor:a];
    
    TDNil(a);
}    

@end
