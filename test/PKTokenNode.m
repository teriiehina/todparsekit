//
//  PKTokenNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKTokenNode.h"
#import <ParseKit/PKToken.h>

@interface PKTokenNode ()
@property (nonatomic, retain, readwrite) PKToken *token;
@end

@implementation PKTokenNode

+ (id)tokenNodeWithToken:(PKToken *)s {
    return [self initWithToken:s];
}


- (id)initWithToken:(PKToken *)s {
    if (self = [super init]) {
        self.token = s;
    }
    return self;
}


- (void)dealloc {
    self.token = nil;
    [super dealloc];
}

@synthesize token;
@end
