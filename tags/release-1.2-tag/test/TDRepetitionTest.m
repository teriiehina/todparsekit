//
//  TDRepetitionTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDRepetitionTest.h"

@interface TDParser ()
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TDRepetitionTest

- (void)setUp {
}


- (void)tearDown {
    [a release];
    [p release];
}


#pragma mark -

- (void)testWordRepetitionAllMatchesForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
    NSLog(@"all: %@", all);
    
    TDNotNil(all);
    NSUInteger c = all.count;
    TDEquals((NSUInteger)4, c);
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    
    TDAssembly *result = [p bestMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description]);
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];

    TDAssembly *result = [p bestMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar]foo/bar^123", [result description]);
}


- (void)testWordRepetitionAllMatchesForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
    NSLog(@"all: %@", all);
    
    TDNotNil(all);
    NSUInteger c = all.count;
    TDEquals((NSUInteger)3, c);
}    


- (void)testWordRepetitionAllMatchesFooSpace123SpaceBaz {
    s = @"foo 123 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
    NSLog(@"all: %@", all);
    
    TDNotNil(all);
    NSUInteger c = all.count;
    TDEquals((NSUInteger)2, c);
}    


- (void)testNumRepetitionAllMatchesForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
    NSLog(@"all: %@", all);
    
    TDNotNil(all);
    NSUInteger c = all.count;
    TDEquals((NSUInteger)1, c);
}    


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    TDAssembly *result = [p completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description]);
}    


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    TDAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}    


- (void)testWordRepetitionCompleteMatchFor456SpaceBarSpace123 {
    s = @"456 bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    TDAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}    


- (void)testNumRepetitionCompleteMatchFor456SpaceBarSpace123 {
    s = @"456 bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    TDAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}    


- (void)testNumRepetitionAllMatchesFor123Space456SpaceBaz {
    s = @"123 456 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
    
    TDNotNil(all);
    NSInteger c = all.count;
    TDEquals((NSUInteger)3, (NSUInteger)c);
}    


- (void)testNumRepetitionBestMatchFor123Space456SpaceBaz {
    s = @"123 456 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    TDAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123, 456]123/456^baz", [result description]);
}    


- (void)testNumRepetitionCompleteMatchFor123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123]123^", [result description]);
}    


- (void)testWordRepetitionCompleteMatchFor123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}    


- (void)testWordRepetitionBestMatchForFoo {
    s = @"foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    TDAssembly *result = [p bestMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[foo]foo^", [result description]);
}

@end
