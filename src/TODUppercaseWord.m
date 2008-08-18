//
//  TODUppercaseWord.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODUppercaseWord.h>
#import <TODParseKit/TODToken.h>

@implementation TODUppercaseWord

- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	if (!tok.isWord) {
		return NO;
	}
	
	NSString *s = tok.stringValue;
	return s.length && isupper([s characterAtIndex:0]);
}

@end
