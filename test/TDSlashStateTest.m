//
//  TDSlashStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSlashStateTest.h"

@implementation TDSlashStateTest

- (void)setUp {
    slashState = [[TDSlashState alloc] init];
}


- (void)tearDown {
    [slashState release];
    [r release];
}


- (void)testSpace {
    s = @" ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEqualObjects(t.stringValue, @"/");
    TDAssertTrue(t.isSymbol);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlash {
    s = @"/";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEqualObjects(t.stringValue, @"/");
    TDAssertTrue(t.isSymbol);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSpaceSlash {
    s = @" /";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSpaceSlashSpace {
    s = @" / ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashAbc {
    s = @"/abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEqualObjects(t.stringValue, @"/");
    TDAssertTrue(t.isSymbol);
    TDAssertEquals((NSInteger)'a', [r read]);
}


- (void)testSlashSpaceAbc {
    s = @"/ abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEqualObjects(t.stringValue, @"/");
    TDAssertTrue(t.isSymbol);
    TDAssertEquals((NSInteger)' ', [r read]);
}


- (void)testSlashSlashAbc {
    s = @"//abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashSlashSpaceAbc {
    s = @"// abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStarSlash {
    s = @"/*abc*/";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbc {
    s = @"/*abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStar {
    s = @"/*abc*";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStarSpace {
    s = @"/*abc* ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcSlash {
    s = @"/*abc/";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcSlashSpace {
    s = @"/*abc/ ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcNewline {
    s = @"/*abc\n";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t);
    TDAssertEquals((NSInteger)-1, [r read]);
}


@end
