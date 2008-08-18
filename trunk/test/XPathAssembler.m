//
//  XPathAssembler.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "XPathAssembler.h"
#import <TODParseKit/TODParseKit.h>
#import "XPathContext.h"

@implementation XPathAssembler

- (id)init {
	self = [super init];
	if (self != nil) {
		self.context = [[[XPathContext alloc] init] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.context = nil;
	[super dealloc];
}


- (void)reset {
	[context resetWithCurrentNode:nil];
}


- (void)workOnAxisSpecifierAssembly:(TODAssembly *)a {
	//NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
	
	//TODToken *tok = [a pop];
	
}


- (void)workOnNodeTestAssembly:(TODAssembly *)a {
	//NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}


- (void)workOnPredicateAssembly:(TODAssembly *)a {
	//NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}

// [4] Step ::=   	AxisSpecifier NodeTest Predicate* | AbbreviatedStep	
- (void)workOnStepAssembly:(TODAssembly *)a {
	//NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}



@synthesize context;
@end
