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
    r = [[PKReader alloc] init];
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
    TDEquals(TDEOF, [r read]);
}


- (void)testSlash {
    s = @"/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlash {
    s = @"/";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashSlash {
    s = @"//";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, s);
    TDTrue(tok.isComment);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, s);
    TDTrue(tok.isComment);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashAbc {
    s = @"/abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testReportSlashAbc {
    s = @"/abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSlashSpaceAbc {
    s = @"/ abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testReportSlashSpaceAbc {
    s = @"/ abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok.stringValue, @"/");
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testSlashSlashAbc {
    s = @"//abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashSlashAbc {
    s = @"//abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashSlashSpaceAbc {
    s = @"// abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashSlashSpaceAbc {
    s = @"// abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcStarSlash {
    s = @"/*abc*/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbcStarSlash {
    s = @"/*abc*/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbcStarStar {
    s = @"/*abc**";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAStarStarSpaceA {
    s = @"/*a**/ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*a**/");
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testReportSlashStarAbcStarStarSpaceA {
    s = @"/*abc**/ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*abc**/");
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testReportSlashStarStarSlash {
    s = @"/**/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarStarStarSlash {
    s = @"/***/";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarStarSlashSpace {
    s = @"/**/ ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/**/");
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testReportSlashStarAbcStarSpaceStarSpaceA {
    s = @"/*abc* */ a";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/*abc* */");
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testSlashStarAbc {
    s = @"/*abc";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbc {
    s = @"/*abc";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcStar {
    s = @"/*abc*";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcStarSpace {
    s = @"/*abc* ";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbcStarSpace {
    s = @"/*abc* ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcSlash {
    s = @"/*abc/";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcSlashSpace {
    s = @"/*abc/ ";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbcSlashSpace {
    s = @"/*abc/ ";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}


- (void)testSlashStarAbcNewline {
    s = @"/*abc\n";
    r.string = s;
    t.string = s;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals(TDEOF, [r read]);
}


- (void)testReportSlashStarAbcNewline {
    s = @"/*abc\n";
    r.string = s;
    t.string = s;
    slashState.reportsCommentTokens = YES;
    TDToken *tok = [slashState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(TDEOF, [r read]);
}

@end
