//
//  TDCommentStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCommentStateTest.h"

@implementation TDCommentStateTest

- (void)setUp {
    r = [[TDReader alloc] init];
    t = [[TDTokenizer alloc] init];
    commentState = t.commentState;
}


- (void)tearDown {
    [r release];
    [t release];
}


- (void)testSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], -1);
}


- (void)testReportSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals([r read], -1);
}


- (void)testTurnOffSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    [commentState removeSingleLineStartSymbol:@"//"];
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"/");
    TDEquals([r read], (NSInteger)'/');
}


- (void)testHashFoo {
    s = @"# foo";
    r.string = s;
    t.string = s;
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");

    r.string = s;
    t.string = s;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testAddHashFoo {
    s = @"# foo";
    r.string = s;
    t.string = s;
    [commentState addSingleLineStartSymbol:@"#"];
    [t setTokenizerState:commentState from:'#' to:'#'];
    tok = [commentState nextTokenFromReader:r startingWith:'#' tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], -1);
}


- (void)testReportAddHashFoo {
    s = @"# foo";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    [commentState addSingleLineStartSymbol:@"#"];
    [t setTokenizerState:commentState from:'#' to:'#'];
    tok = [commentState nextTokenFromReader:r startingWith:'#' tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals([r read], -1);
}


- (void)testSlashStarFooStarSlash {
    s = @"/* foo */";
    r.string = s;
    t.string = s;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], -1);
}


- (void)testSlashStarFooStarSlashSpace {
    s = @"/* foo */ ";
    r.string = s;
    t.string = s;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], -1);
}


- (void)testReportSlashStarFooStarSlash {
    s = @"/* foo */";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    TDEquals([r read], -1);
}


- (void)testReportSlashStarFooStarSlashSpace {
    s = @"/* foo */ ";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);

    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testReportSlashStarFooStarSlashSpaceA {
    s = @"/* foo */ a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testReportSlashStarStarFooStarSlashSpaceA {
    s = @"/** foo */ a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/** foo */");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/** foo */");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testReportSlashStarFooStarStarSlashSpaceA {
    s = @"/* foo **/ a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo **/");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo **/");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testReportSlashStarFooStarSlashSpaceStarSlash {
    s = @"/* foo */ */";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"*");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testTurnOffSlashStarFooStarSlash {
    s = @"/* foo */";
    r.string = s;
    t.string = s;
    [commentState removeMultiLineStartSymbol:@"/*"];
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"/");
}


- (void)testReportSlashStarFooStar {
    s = @"/* foo *";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
}


- (void)testReportBalancedSlashStarFooStar {
    s = @"/* foo *";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    commentState.balancesEOFTerminatedComments = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo **/");
}


- (void)testReportBalancedSlashStarFoo {
    s = @"/* foo ";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    commentState.balancesEOFTerminatedComments = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
}

@end
