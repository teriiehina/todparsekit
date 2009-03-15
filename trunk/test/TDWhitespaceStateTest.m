//
//  TDWhitespaceStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDWhitespaceStateTest.h"


@implementation TDWhitespaceStateTest

- (void)setUp {
    whitespaceState = [[TDWhitespaceState alloc] init];
}


- (void)tearDown {
    [whitespaceState release];
    [r release];
}


- (void)testSpace {
    s = @" ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testTwoSpaces {
    s = @"  ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testNil {
    s = nil;
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testNull {
    s = NULL;
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testEmptyString {
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testTab {
    s = @"\t";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testNewLine {
    s = @"\n";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testCarriageReturn {
    s = @"\r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSpaceCarriageReturn {
    s = @" \r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSpaceTabNewLineSpace {
    s = @" \t\n ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSpaceA {
    s = @" a";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}

- (void)testSpaceASpace {
    s = @" a ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testTabA {
    s = @"\ta";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testNewLineA {
    s = @"\na";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testCarriageReturnA {
    s = @"\ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testNewLineSpaceCarriageReturnA {
    s = @"\n \ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


#pragma mark -
#pragma mark Significant

- (void)testSignificantSpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantTwoSpaces {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"  ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantEmptyString {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantTab {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\t";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantNewLine {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\n";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantCarriageReturn {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantSpaceCarriageReturn {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" \r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantSpaceTabNewLineSpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" \t\n ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testSignificantSpaceA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" a";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@" ", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSignificantSpaceASpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" a ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@" ", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSignificantTabA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\ta";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\t", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSignificantNewLineA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\na";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\n", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSignificantCarriageReturnA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\r", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testSignificantNewLineSpaceCarriageReturnA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\n \ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\n \r", tok.stringValue);
    TDEquals((TDUniChar)'a', [r read]);
}

@end