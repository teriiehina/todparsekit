//
//  PKRuleNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKRuleNode.h"

@interface PKRuleNode ()
@property (nonatomic, copy, readwrite) NSString *name;
@end

@implementation PKRuleNode

+ (id)ruleNodeWithName:(NSString *)s {
    return [self initWithName:s];
}


- (id)initWithName:(NSString *)s {
    if (self = [super init]) {
        self.name = s;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    [super dealloc];
}

@synthesize name;
@end
