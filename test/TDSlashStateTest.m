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
    r = [[TDReader alloc] init];
    t = [[TDTokenizer alloc] init];
    slashState = t.slashState;
}


- (void)tearDown {
    [r release];
    [t release];
}


- (void)testSpace {
    s = @" ";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlash {
    s = @"/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlash {
    s = @"/";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashSlash {
    s = @"//";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, s);
    TDTrue(tok.isComment);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, s);
    TDTrue(tok.isComment);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashAbc {
    s = @"/abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)'a', [r read]);
}


- (void)testReportSlashAbc {
    s = @"/abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)'a', [r read]);
}


- (void)testSlashSpaceAbc {
    s = @"/ abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testReportSlashSpaceAbc {
    s = @"/ abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testSlashSlashAbc {
    s = @"//abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashSlashAbc {
    s = @"//abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashSlashSpaceAbc {
    s = @"// abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashSlashSpaceAbc {
    s = @"// abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStarSlash {
    s = @"/*abc*/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbcStarSlash {
    s = @"/*abc*/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbcStarStar {
    s = @"/*abc**";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAStarStarSpaceA {
    s = @"/*a**/ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*a**/");
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testReportSlashStarAbcStarStarSpaceA {
    s = @"/*abc**/ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*abc**/");
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testReportSlashStarStarSlash {
    s = @"/**/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarStarStarSlash {
    s = @"/***/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarStarSlashSpace {
    s = @"/**/ ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/**/");
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testReportSlashStarAbcStarSpaceStarSpaceA {
    s = @"/*abc* */ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*abc* */");
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testSlashStarAbc {
    s = @"/*abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbc {
    s = @"/*abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStar {
    s = @"/*abc*";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcStarSpace {
    s = @"/*abc* ";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbcStarSpace {
    s = @"/*abc* ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcSlash {
    s = @"/*abc/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcSlashSpace {
    s = @"/*abc/ ";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbcSlashSpace {
    s = @"/*abc/ ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testSlashStarAbcNewline {
    s = @"/*abc\n";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testReportSlashStarAbcNewline {
    s = @"/*abc\n";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals((NSInteger)-1, [r read]);
}

@end
