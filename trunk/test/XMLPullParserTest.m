//
//  XMLPullParserTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XMLPullParserTest.h"

@implementation XMLPullParserTest

- (void)test {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"xml"];
	
	NSLog(@"\n\npath: %@\n\n", path);

	XMLPullParser *p = [XMLPullParser parserWithContentsOfFile:path];
	NSInteger ret = [p read];
	while (ret == 1) {
		NSLog(@"nodeType: %d, name: %@", p.nodeType, p.name);
		ret = [p read];
		
	}
}

@end
