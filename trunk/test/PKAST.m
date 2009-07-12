//
//  PKAST.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKAST.h"

@interface PKAST ()
@property (nonatomic, retain) PKToken *token;
@property (nonatomic, retain) NSMutableArray *children;
@end

@implementation PKAST

+ (id)ASTWithToken:(PKToken *)tok {
    return [[[self alloc] initWithToken:tok] autorelease];
}


- (id)init {
    return [self initWithToken:nil];
}


- (id)initWithToken:(PKToken *)tok {
    if (self = [super init]) {
        self.token = tok;
    }
    return self;
}


- (void)dealloc {
    self.token = nil;
    self.children = nil;
    [super dealloc];
}


- (void)addChild:(PKAST *)c {
    if (!children) {
        self.children = [NSMutableArray array];
    }
    [children addObject:c];
}

@synthesize token;
@synthesize children;
@end
