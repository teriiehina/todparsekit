//
//  TDReaderTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDReaderTest.h"


@implementation TDReaderTest

- (void)setUp {
    string = @"abcdefghijklmnopqrstuvwxyz";
    [string retain];
    reader = [[TDReader alloc] initWithString:string];
}


- (void)tearDown {
    [string release];
    [reader release];
}


#pragma mark -

- (void)testReadCharsMatch {
    TDAssertNotNil(reader);
    NSInteger len = [string length];
    NSInteger c;
    NSInteger i = 0;
    for ( ; i < len; i++) {
        c = [string characterAtIndex:i];
        TDAssertEquals(c, [reader read]);
    }
}


- (void)testReadTooFar {
    NSInteger len = [string length];
    NSInteger i = 0;
    for ( ; i < len; i++) {
        [reader read];
    }
    TDAssertEquals((NSInteger)-1, [reader read]);
}


- (void)testUnread {
    [reader read];
    [reader unread];
    NSInteger a = 'a';
    TDAssertEquals(a, [reader read]);

    [reader read];
    [reader read];
    [reader unread];
    NSInteger c = 'c';
    TDAssertEquals(c, [reader read]);
}


- (void)testUnreadTooFar {
    [reader unread];
    NSInteger a = 'a';
    TDAssertEquals(a, [reader read]);

    [reader unread];
    [reader unread];
    [reader unread];
    [reader unread];
    NSInteger a2 = 'a';
    TDAssertEquals(a2, [reader read]);
}

@end
