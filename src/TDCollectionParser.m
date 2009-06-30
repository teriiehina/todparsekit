//
//  TDCollectionParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDCollectionParser.h>

@interface TDCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@implementation TDCollectionParser

- (id)init {
    if (self = [super init]) {
        self.subparsers = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.subparsers = nil;
    [super dealloc];
}


- (void)add:(TDParser *)p {
    if (!p) {
        
    }
    //NSParameterAssert(p);
    //NSParameterAssert([p isKindOfClass:[TDParser class]]);
    [subparsers addObject:p];
}


- (TDParser *)parserNamed:(NSString *)s {
    if ([name isEqualToString:s]) {
        return self;
    } else {
        // do bredth-first search
        for (TDParser *p in subparsers) {
            if ([p.name isEqualToString:s]) {
                return p;
            }
        }
        for (TDParser *p in subparsers) {
            TDParser *sub = [p parserNamed:s];
            if (sub) {
                return sub;
            }
        }
    }
    return nil;
}

@synthesize subparsers;
@end
