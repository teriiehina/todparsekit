//
//  XPathAssembler.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "XPathAssembler.h"
#import <TDParseKit/TDParseKit.h>
#import "XPathContext.h"

@implementation XPathAssembler

- (id)init {
        if (self = [super init]) {
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


- (void)workOnAxisSpecifierAssembly:(TDAssembly *)a {
    //NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
    
    //TDToken *tok = [a pop];
    
}


- (void)workOnNodeTestAssembly:(TDAssembly *)a {
    //NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}


- (void)workOnPredicateAssembly:(TDAssembly *)a {
    //NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}

// [4] Step ::=       AxisSpecifier NodeTest Predicate* | AbbreviatedStep    
- (void)workOnStepAssembly:(TDAssembly *)a {
    //NSLog(@"\n\n %s\n\n %@ \n\n", _cmd, a);
}



@synthesize context;
@end
