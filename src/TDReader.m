//
//  TDReader.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDReader.h>

@implementation TDReader

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self != nil) {
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    [super dealloc];
}


- (NSString *)string {
    return [[string retain] autorelease];
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [self willChangeValueForKey:@"string"];
        [string autorelease];
        string = [s copy];
        [self didChangeValueForKey:@"string"];
    }
    // reset cursor
    cursor = 0;
}


- (NSInteger)read {
    NSUInteger len = string.length;
    if (0 == len || cursor > len - 1) {
        return -1;
    }
    return [string characterAtIndex:cursor++];
}


- (void)unread {
    cursor = (0 == cursor) ? 0 : cursor - 1;
}

@end
