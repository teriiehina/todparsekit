//
//  TODSlashStateTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSlashStateTest.h"

@implementation TODSlashStateTest

- (void)setUp {
	slashState = [[TODSlashState alloc] init];
}


- (void)tearDown {
	[slashState release];
	[r release];
}


- (void)testSpace {
	s = @" ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(t.stringValue, @"/", @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlash {
	s = @"/";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(t.stringValue, @"/", @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceSlash {
	s = @" /";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceSlashSpace {
	s = @" / ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashAbc {
	s = @"/abc";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(t.stringValue, @"/", @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSlashSpaceAbc {
	s = @"/ abc";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(t.stringValue, @"/", @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testSlashSlashAbc {
	s = @"//abc";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashSlashSpaceAbc {
	s = @"// abc";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcStarSlash {
	s = @"/*abc*/";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbc {
	s = @"/*abc";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcStar {
	s = @"/*abc*";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcStarSpace {
	s = @"/*abc* ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcSlash {
	s = @"/*abc/";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcSlashSpace {
	s = @"/*abc/ ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSlashStarAbcNewline {
	s = @"/*abc\n";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


@end
