//
//  TODRepetitionTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODRepetitionTest.h"

@interface TODParser ()
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TODRepetitionTest

- (void)setUp {
}


- (void)tearDown {
	[a release];
	[p release];
}


#pragma mark -

- (void)testWordRepetitionAllMatchesForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
	NSLog(@"all: %@", all);
	
	STAssertNotNil(all, @"");
	NSInteger c = all.count;
	STAssertEquals(4, c, @"");
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	
	TODAssembly *result = [p bestMatchFor:a];	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpace123 {
	s = @"foo bar 123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];

	TODAssembly *result = [p bestMatchFor:a];	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar]foo/bar^123", [result description], @"");
}


- (void)testWordRepetitionAllMatchesForFooSpaceBarSpace123 {
	s = @"foo bar 123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
	NSLog(@"all: %@", all);
	
	STAssertNotNil(all, @"");
	NSInteger c = all.count;
	STAssertEquals(3, c, @"");
}	


- (void)testWordRepetitionAllMatchesFooSpace123SpaceBaz {
	s = @"foo 123 baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
	NSLog(@"all: %@", all);
	
	STAssertNotNil(all, @"");
	NSInteger c = all.count;
	STAssertEquals(2, c, @"");
}	


- (void)testNumRepetitionAllMatchesForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODNum num]];
	
	NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
	NSLog(@"all: %@", all);
	
	STAssertNotNil(all, @"");
	NSInteger c = all.count;
	STAssertEquals(1, c, @"");
}	


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}	


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpace123 {
	s = @"foo bar 123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}	


- (void)testWordRepetitionCompleteMatchFor456SpaceBarSpace123 {
	s = @"456 bar 123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}	


- (void)testNumRepetitionCompleteMatchFor456SpaceBarSpace123 {
	s = @"456 bar 123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODNum num]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}	


- (void)testNumRepetitionAllMatchesFor123Space456SpaceBaz {
	s = @"123 456 baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODNum num]];
	
	NSSet *all = [p allMatchesFor:[NSSet setWithObject:a]];
	
	STAssertNotNil(all, @"");
	NSInteger c = all.count;
	STAssertEquals(3, c, @"");
}	


- (void)testNumRepetitionBestMatchFor123Space456SpaceBaz {
	s = @"123 456 baz";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODNum num]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123, 456]123/456^baz", [result description], @"");
}	


- (void)testNumRepetitionCompleteMatchFor123 {
	s = @"123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODNum num]];
	
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^", [result description], @"");
}	


- (void)testWordRepetitionCompleteMatchFor123 {
	s = @"123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}	


- (void)testWordRepetitionBestMatchForFoo {
	s = @"foo";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [[TODRepetition alloc] initWithSubparser:[TODWord word]];
	
	TODAssembly *result = [p bestMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]foo^", [result description], @"");
}

@end
