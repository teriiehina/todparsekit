//
//  TDCollectionParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDCollectionParser.h>

@interface TDCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@implementation TDCollectionParser

- (id)init {
    self = [super init];
    if (self) {
        self.subparsers = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.subparsers = nil;
    [super dealloc];
}


- (TDParser *)add:(TDParser *)p {
    NSParameterAssert(p);
    [subparsers addObject:p];
    return self;
}

@synthesize subparsers;
@end
