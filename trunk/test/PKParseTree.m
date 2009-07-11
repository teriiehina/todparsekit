//
//  PKParseTree.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKParseTree.h"
#import "PKRuleNode.h"
#import "PKTokenNode.h"

@interface PKParseTree ()
@property (nonatomic, retain, readwrite) NSMutableArray *children;
@end

@implementation PKParseTree

- (void)dealloc {
    self.children = nil;
    [super dealloc];
}


- (PKRuleNode *)addChildRule:(NSString *)name {
    NSParameterAssert([name length]);
    PKRuleNode *n = [PKRuleNode ruleNodeWithName:name];
    [self addChild:n];
    return n;
}


- (PKTokenNode *)addChildToken:(PKToken *)tok {
    NSParameterAssert([[tok stringValue] length]);
    PKTokenNode *n = [PKTokenNode tokenNodeWithToken:tok];
    [self addChild:n];
    return n;
}


- (void)addChild:(PKParseTree *)tr {
    NSParameterAssert(tr);
    if (!children) {
        self.children = [NSMutableArray array];
    }
    [children addObject:tr];
}

@synthesize children;
@end
