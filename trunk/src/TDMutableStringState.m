//
//  TDMutableStringState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDMutableStringState.h>

@implementation TDMutableStringState

- (void)dealloc {
	self.stringbuf = nil;
	[super dealloc];
}


- (void)reset {
	self.stringbuf = [NSMutableString string];
}

@synthesize stringbuf;
@end
