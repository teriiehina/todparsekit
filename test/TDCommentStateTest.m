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
    TDEquals(tok.offset, (NSUInteger)-1);
    TDEquals([r read], TDEOF);
}


- (void)testReportSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.offset, (NSUInteger)0);
    TDEqualObjects([t nextToken], [TDToken EOFToken]);
}


- (void)testReportSpaceSlashSlashFoo {
    s = @" // foo";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"// foo");
    TDEquals(tok.offset, (NSUInteger)1);
    TDEqualObjects([t nextToken], [TDToken EOFToken]);
}


- (void)testTurnOffSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    [commentState removeSingleLineStartMarker:@"//"];
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"/");
    TDEquals(tok.offset, (NSUInteger)0);
    TDEquals([r read], (TDUniChar)'/');
}


- (void)testHashFoo {
    s = @"# foo";
    r.string = s;
    t.string = s;
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.offset, (NSUInteger)0);
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    TDEquals(tok.offset, (NSUInteger)2);

    r.string = s;
    t.string = s;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.offset, (NSUInteger)0);
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
    TDEquals(tok.offset, (NSUInteger)1);
}


- (void)testAddHashFoo {
    s = @"# foo";
    t.string = s;
    [commentState addSingleLineStartMarker:@"#"];
    [t setTokenizerState:commentState from:'#' to:'#'];
    tok = [t nextToken];
    TDTrue(tok == [TDToken EOFToken]);
    TDEquals(tok.offset, (NSUInteger)-1);
}


- (void)testReportAddHashFoo {
    s = @"# foo";
    t.string = s;
    commentState.reportsCommentTokens = YES;
    [commentState addSingleLineStartMarker:@"#"];
    [t setTokenizerState:commentState from:'#' to:'#'];
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.offset, (NSUInteger)0);
}


- (void)testSlashStarFooStarSlash {
    s = @"/* foo */";
    t.string = s;
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], TDEOF);
}


- (void)testSlashStarFooStarSlashSpace {
    s = @"/* foo */ ";
    t.string = s;
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
    TDEquals([r read], TDEOF);
}


- (void)testReportSlashStarFooStarSlash {
    s = @"/* foo */";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    TDEquals([t nextToken], [TDToken EOFToken]);
    TDEquals(tok.offset, (NSUInteger)0);
}


- (void)testReportSlashStarFooStarSlashSpace {
    s = @"/* foo */ ";
    t.string = s;
    commentState.reportsCommentTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"/* foo */");
    TDEquals(tok.offset, (NSUInteger)0);
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);

    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEquals(tok.offset, (NSUInteger)0);
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
    [commentState removeMultiLineStartMarker:@"/*"];
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


- (void)testXMLFooStarXMLA {
    s = @"<!-- foo --> a";
    r.string = s;
    t.string = s;
    [commentState addMultiLineStartMarker:@"<!--" endMarker:@"-->"];
    [t setTokenizerState:commentState from:'<' to:'<'];
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testReportXMLFooStarXMLA {
    s = @"<!-- foo --> a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    [commentState addMultiLineStartMarker:@"<!--" endMarker:@"-->"];
    [t setTokenizerState:commentState from:'<' to:'<'];
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"<!-- foo -->");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"<!-- foo -->");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testXXMarker {
    s = @"XX foo XX a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    [commentState addMultiLineStartMarker:@"XX" endMarker:@"XX"];
    [t setTokenizerState:commentState from:'X' to:'X'];
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"XX foo XX");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    TDTrue(tok.isComment);
    TDEqualObjects(tok.stringValue, @"XX foo XX");
    tok = [t nextToken];
    TDTrue(tok.isWhitespace);
    TDEqualObjects(tok.stringValue, @" ");
}


- (void)testXXMarkerFalseStartMarkerMatch {
    s = @"X foo X a";
    r.string = s;
    t.string = s;
    commentState.reportsCommentTokens = YES;
    [commentState addMultiLineStartMarker:@"XX" endMarker:@"XX"];
    [t setTokenizerState:commentState from:'X' to:'X'];
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"X");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"X");
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"a");
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}

@end
