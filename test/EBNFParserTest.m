//
//  EBNFParserTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "EBNFParserTest.h"
#import "EBNFParser.h"

@implementation EBNFParserTest

- (void)test {
	//NSString *s = @"foo (bar|baz)*;";
	NSString *s = @"$baz = bar; ($baz|foo)*;";
	//NSString *s = @"foo;";
	EBNFParser *p = [[[EBNFParser alloc] init] autorelease];
	
	//	TODAssembly *a = [p bestMatchFor:[TODTokenAssembly assemblyWithString:s]];
	//	NSLog(@"a: %@", a);
	//	NSLog(@"a.target: %@", a.target);
	
	TODParser *res = [p parse:s];
	//	NSLog(@"res: %@", res);
	//	NSLog(@"res: %@", res.string);
	//	NSLog(@"res.subparsers: %@", res.subparsers);
	//	NSLog(@"res.subparsers 0: %@", [[res.subparsers objectAtIndex:0] string]);
	//	NSLog(@"res.subparsers 1: %@", [[res.subparsers objectAtIndex:1] string]);
	
	s = @"bar foo bar foo";
	TODAssembly *a = [res completeMatchFor:[TODTokenAssembly assemblyWithString:s]];
	NSLog(@"\n\na: %@\n\n", a);
	
}

@end
