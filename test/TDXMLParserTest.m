//
//  TDXMLParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDXMLParserTest.h"

@implementation TDXMLParserTest

- (void)setUp {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml" ofType:@"grammar"];
	NSString *g = [NSString stringWithContentsOfFile:path];
	p = [[TDParserFactory factory] parserFromGrammar:g assembler:self];
    t = p.tokenizer;
}


- (void)testSTag {
	t.string = @"<foo>";
	NSLog(@"p: %@", p);
//    NSLog(@"document: %@", [p parserNamed:@"document"]);
//    NSLog(@"comment: %@", [p parserNamed:@"comment"]);
//    NSLog(@"content: %@", [p parserNamed:@"content"]);
////	NSLog(@"sTag: %@", [p parserNamed:@"sTag"]);
//    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
////	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);
}


- (void)test1 {
//	t.string = @"<foo></foo>";
//    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);

//	t.string = @"<foo/>";
//    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);

}

@end
