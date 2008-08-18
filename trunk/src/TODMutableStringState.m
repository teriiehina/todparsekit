//
//  TODMutableStringState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODMutableStringState.h>

@implementation TODMutableStringState

- (void)dealloc {
	self.stringbuf = nil;
	[super dealloc];
}


- (void)reset {
	self.stringbuf = [NSMutableString string];
}

@synthesize stringbuf;
@end
