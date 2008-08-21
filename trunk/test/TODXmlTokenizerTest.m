//
//  TODXmlTokenizerTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTokenizerTest.h"

@implementation TODXmlTokenizerTest

- (void)testFoo {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"xml"];

	TODXmlTokenizer *t = [TODXmlTokenizer tokenizerWithContentsOfFile:path];
	NSLog(@"\n\n %@\n\n", t);
	
	TODXmlToken *eof = [TODXmlToken EOFToken];
	TODXmlToken *tok = nil;
	
	while ((tok = [t nextToken]) != eof) {
		NSLog(@" %@", [tok debugDescription]);
	}
}

@end
