//
//  TDCharacterAssemblyTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCharacterAssemblyTest.h"

@implementation TDCharacterAssemblyTest

- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];

    TDNotNil(a);
    TDEquals((int)3, (int)s.length);
    TDEquals(0, a.objectsConsumed);
    TDEquals(3, a.objectsRemaining);
    TDEquals(YES, [a hasMore]);
    
    id obj = [a next];
    TDEqualObjects(obj, [NSNumber numberWithInteger:'a']);
    TDEquals((int)3, (int)s.length);
    TDEquals(1, a.objectsConsumed);
    TDEquals(2, a.objectsRemaining);
    TDEquals(YES, [a hasMore]);

    obj = [a next];
    TDEqualObjects(obj, [NSNumber numberWithInteger:'b']);
    TDEquals((int)3, (int)s.length);
    TDEquals(2, a.objectsConsumed);
    TDEquals(1, a.objectsRemaining);
    TDEquals(YES, [a hasMore]);

    obj = [a next];
    TDEqualObjects(obj, [NSNumber numberWithInteger:'c']);
    TDEquals((int)3, (int)s.length);
    TDEquals(3, a.objectsConsumed);
    TDEquals(0, a.objectsRemaining);
    TDEquals(NO, [a hasMore]);

    obj = [a next];
    TDNil(obj);
    TDEquals((int)3, (int)s.length);
    TDEquals(3, a.objectsConsumed);
    TDEquals(0, a.objectsRemaining);
    TDEquals(NO, [a hasMore]);
}

@end
