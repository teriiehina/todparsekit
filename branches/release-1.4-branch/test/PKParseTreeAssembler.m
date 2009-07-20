//
//  PKParseTreeAssembler.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKParseTreeAssembler.h"
#import "PKParseTree.h"
#import "PKRuleNode.h"
#import "PKTokenNode.h"
#import <ParseKit/ParseKit.h>

@interface PKParseTreeAssembler ()
@property (nonatomic, retain, readwrite) PKParseTree *rootNode;
@property (nonatomic, assign, readwrite) PKParseTree *currentNode;
@end

@implementation PKParseTreeAssembler

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[PKParseTree alloc] init] autorelease];
        self.currentNode = rootNode;
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    currentNode = nil;
    [super dealloc];
}


- (void)workOnRule:(PKAssembly *)a {
    id name = [a pop];
    NSAssert([name isKindOfClass:[NSString class]], @"");
    PKRuleNode *n = [currentNode addChildRule:name];
    self.currentNode = n;
}


- (void)workOnToken:(PKAssembly *)a {
    id tok = [a pop];
    NSAssert([tok isKindOfClass:[PKToken class]], @"");
    [currentNode addChildToken:tok];
}

@synthesize rootNode;
@synthesize currentNode;
@end
