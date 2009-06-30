//
//  TDParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDParserTest.h"


@implementation TDParserTest

- (void)setUp {
}


- (void)tearDown {
}


#pragma mark -

- (void)testMath {
    s = @"2 4 6 8";
    a = [PKTokenAssembly assemblyWithString:s];
    
    p = [PKRepetition repetitionWithSubparser:[TDNum num]];
    
    PKAssembly *result = [p completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[2, 4, 6, 8]2/4/6/8^", [result description]);
}


- (void)testMiniMath {
    s = @"4.5 - 5.6 - 222.0";
    a = [PKTokenAssembly assemblyWithString:s];
    
    PKSequence *minusNum = [PKSequence sequence];
    [minusNum add:[[TDSymbol symbolWithString:@"-"] discard]];
    [minusNum add:[TDNum num]];
    
    PKSequence *e = [PKSequence sequence];
    [e add:[TDNum num]];
    [e add:[PKRepetition repetitionWithSubparser:minusNum]];
    
    PKAssembly *result = [e completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[4.5, 5.6, 222.0]4.5/-/5.6/-/222.0^", [result description]);
}


- (void)testMiniMathWithBrackets {
    s = @"[4.5 - 5.6 - 222.0]";
    a = [PKTokenAssembly assemblyWithString:s];
    
    PKSequence *minusNum = [PKSequence sequence];
    [minusNum add:[[TDSymbol symbolWithString:@"-"] discard]];
    [minusNum add:[TDNum num]];
    
    PKSequence *e = [PKSequence sequence];
    [e add:[[TDSymbol symbolWithString:@"["] discard]];
    [e add:[TDNum num]];
    [e add:[PKRepetition repetitionWithSubparser:minusNum]];
    [e add:[[TDSymbol symbolWithString:@"]"] discard]];
    
    PKAssembly *result = [e completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[4.5, 5.6, 222.0][/4.5/-/5.6/-/222.0/]^", [result description]);
}


- (void)testHotHotSteamingHotCoffee {
    PKAlternation *adjective = [PKAlternation alternation];
    [adjective add:[TDLiteral literalWithString:@"hot"]];
    [adjective add:[TDLiteral literalWithString:@"steaming"]];

    PKRepetition *adjectives = [PKRepetition repetitionWithSubparser:adjective];
    
    PKSequence *sentence = [PKSequence sequence];
    [sentence add:adjectives];
    [sentence add:[TDLiteral literalWithString:@"coffee"]];

    s = @"hot hot steaming hot coffee";
    a = [PKTokenAssembly assemblyWithString:s];
    
    PKAssembly *result = [sentence bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[hot, hot, steaming, hot, coffee]hot/hot/steaming/hot/coffee^", [result description]);
}
    

- (void)testList {
    PKAssembly *result = nil;

    PKSequence *commaTerm = [PKSequence sequence];
    [commaTerm add:[[TDSymbol symbolWithString:@","] discard]];
    [commaTerm add:[TDWord word]];

    PKSequence *actualList = [PKSequence sequence];
    [actualList add:[TDWord word]];
    [actualList add:[PKRepetition repetitionWithSubparser:commaTerm]];
    
    PKSequence *list = [PKSequence sequence];
    [list add:[[TDSymbol symbolWithString:@"["] discard]];
    [list add:actualList];
    [list add:[[TDSymbol symbolWithString:@"]"] discard]];

    s = @"[foo, bar, baz]";
    a = [PKTokenAssembly assemblyWithString:s];

    result = [list bestMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz][/foo/,/bar/,/baz/]^", [result description]);
}


- (void)testJavaScriptStatement {
    s = @"123 'boo'";
    a = [PKTokenAssembly assemblyWithString:s];
    
    PKAlternation *literals = [PKAlternation alternation];
    [literals add:[TDQuotedString quotedString]];
    [literals add:[TDNum num]];
    
    PKAssembly *result = [literals bestMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[123]123^'boo'", [result description]);
}

@end
