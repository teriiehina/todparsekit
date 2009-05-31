//
//  TDParserFactoryTest2.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParserFactoryTest2.h"

@implementation TDParserFactoryTest2

- (void)setUp {
    factory = [TDParserFactory factory];
}


- (void)test1 {
    g = @"@start = Word (Num | QuotedString*) Num;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    TDEqualObjects([lp class], [TDSequence class]);

//    NSArray *subs = ((TDSequence *)lp).subparsers;
  //  NSLog(@"subs: %@", subs);
//    TDEquals((NSUInteger)1, subs.count);
//    TDTrue([lp class] == [TDSequence class]);
}

@end
