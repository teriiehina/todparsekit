//
//  TODXmlTerminal.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTerminal.h"
#import "TODXmlToken.h"

@implementation TODXmlTerminal

- (void)dealloc {
	self.tok = nil;
	[super dealloc];
}

@synthesize tok;
@end
