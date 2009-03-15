//
//  TDSymbolStateTestok.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSymbolStateTest.h"

@implementation TDSymbolStateTest

- (void)setUp {
    symbolState = [[TDSymbolState alloc] init];
}


- (void)tearDown {
    [symbolState release];
    [r release];
}


- (void)testDot {
    s = @".";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testDotA {
    s = @".a";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)'a', [r read]);
}


- (void)testDotSpace {
    s = @". ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testDotDot {
    s = @"..";
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)'.', [r read]);
}



- (void)testAddDotDot {
    s = @"..";
    [symbolState add:s];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"..", tok.stringValue);
    TDEqualObjects(@"..", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testAddDotDotSpace {
    s = @".. ";
    [symbolState add:@".."];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"..", tok.stringValue);
    TDEqualObjects(@"..", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testAddColonEqual {
    s = @":=";
    [symbolState add:s];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@":=", tok.stringValue);
    TDEqualObjects(@":=", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testAddColonEqualSpace {
    s = @":= ";
    [symbolState add:@":="];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@":=", tok.stringValue);
    TDEqualObjects(@":=", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testAddGtEqualLtSpace {
    s = @">=< ";
    [symbolState add:@">=<"];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testAddGtEqualLt {
    s = @">=<";
    [symbolState add:s];
    r = [[TDReader alloc] initWithString:s];
    TDToken *tok = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    TDEquals((TDUniChar)-1, [r read]);
}


- (void)testTokenzierAddGtEqualLt {
    s = @">=<";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:s];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddGtEqualLtSpaceFoo {
    s = @">=< foo";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);

    tok = [t nextToken];
    TDEqualObjects(@"foo", tok.stringValue);
    TDEqualObjects(@"foo", tok.value);
    TDTrue(tok.isWord);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddGtEqualLtFoo {
    s = @">=<foo";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    
    tok = [t nextToken];
    TDEqualObjects(@"foo", tok.stringValue);
    TDEqualObjects(@"foo", tok.value);
    TDTrue(tok.isWord);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddGtEqualLtDot {
    s = @">=<.";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddGtEqualLtSpaceDot {
    s = @">=< .";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddGtEqualLtSpaceDotSpace {
    s = @">=< . ";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@">=<", tok.stringValue);
    TDEqualObjects(@">=<", tok.value);
    TDTrue(tok.isSymbol);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddLtBangDashDashSpaceDotSpace {
    s = @"<!-- . ";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"<!--"];
    TDToken *tok = [t nextToken];
    TDEqualObjects(@"<!--", tok.stringValue);
    TDEqualObjects(@"<!--", tok.value);
    TDTrue(tok.isSymbol);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDashGt {
    s = @"-->";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"-->", tok.stringValue);
    TDEqualObjects(@"-->", tok.value);
    
    tok = [t nextToken];
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDashGtSpaceDot {
    s = @"--> .";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"-->", tok.stringValue);
    TDEqualObjects(@"-->", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDashGtSpaceDotSpace {
    s = @"--> . ";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"-->", tok.stringValue);
    TDEqualObjects(@"-->", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDash {
    s = @"--";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"--", tok.stringValue);
    TDEqualObjects(@"--", tok.value);
    
    tok = [t nextToken];
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDashSpaceDot {
    s = @"-- .";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"--", tok.stringValue);
    TDEqualObjects(@"--", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierAddDashDashSpaceDotSpace {
    s = @"-- . ";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"--", tok.stringValue);
    TDEqualObjects(@"--", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@".", tok.stringValue);
    TDEqualObjects(@".", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualButNotEqual {
    s = @"=";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualButNotEqualEqual {
    s = @"==";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqual {
    s = @"====";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"===", tok.stringValue);
    TDEqualObjects(@"===", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqualEqual {
    s = @"=====";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"===", tok.stringValue);
    TDEqualObjects(@"===", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqualEqualSpaceEqual {
    s = @"===== =";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"===", tok.stringValue);
    TDEqualObjects(@"===", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualEqualEqualEqual {
    s = @"====";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualColonEqualButNotEqualColon {
    s = @"=:";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"=:="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@":", tok.stringValue);
    TDEqualObjects(@":", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierRemoveEqualEqual {
    s = @"==";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState remove:@"=="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierRemoveEqualEqualAddEqualEqual {
    s = @"====";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState remove:@"=="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=", tok.stringValue);
    TDEqualObjects(@"=", tok.value);
    
    [t.symbolState add:@"=="];

    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"==", tok.stringValue);
    TDEqualObjects(@"==", tok.value);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}


- (void)testTokenzierEqualColonEqualAndThenEqualColonEqualColon {
    s = @"=:=:";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"=:="];
    TDToken *tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"=:=", tok.stringValue);
    TDEqualObjects(@"=:=", tok.value);
    
    tok = [t nextToken];
    TDEqualObjects(@":", tok.stringValue);
    TDEqualObjects(@":", tok.value);
    TDTrue(tok.isSymbol);
    
    TDEquals([TDToken EOFToken], [t nextToken]);
}

@end
