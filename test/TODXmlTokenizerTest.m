//
//  TODXmlTokenizerTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTokenizerTest.h"
#import "TODXmlDecl.h"
#import "TODXmlStartTag.h"
#import "TODXmlEndTag.h"
#import "TODXmlText.h"
#import "TODXmlSignificantWhitespace.h"
#import "TODXmlTokenAssembly.h"
#import <TODParseKit/TODParseKit.h>

@implementation TODXmlTokenizerTest

- (void)testFoo {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"xml"];

	TODXmlTokenizer *t = [TODXmlTokenizer tokenizerWithContentsOfFile:path];
	NSLog(@"\n\n %@\n\n", t);
	
	TODXmlToken *eof = [TODXmlToken EOFToken];
	TODXmlToken *tok = nil;
	
	while ((tok = [t nextToken]) != eof) {
		//NSLog(@" %@", [tok debugDescription]);
	}
}


- (void)testAppleBoss {
	TODSequence *s = [TODSequence sequence];
	s.name = @"parent sequence";
	[s add:[TODXmlStartTag startTagWithString:@"result"]];
	[s add:[TODXmlStartTag startTagWithString:@"url"]];
	[s add:[TODXmlText text]];
	[s add:[TODXmlEndTag endTagWithString:@"url"]];
	[s add:[TODXmlEndTag endTagWithString:@"result"]];
	
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"small-xml-file" ofType:@"xml"];
	TODXmlTokenAssembly *a = [TODXmlTokenAssembly assemblyWithString:path];
	
	TODAssembly *result = [s bestMatchFor:a];
	NSLog(@"\n\n\n result: %@ \n\n\n", result);
}

@end
