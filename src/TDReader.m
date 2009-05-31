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
    if (self = [super init]) {
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    [super dealloc];
}


- (NSString *)string {
    return string;
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [string release];
        string = [s retain];
        length = string.length;
    }
    // reset cursor
    offset = 0;
}


- (TDUniChar)read {
    if (0 == length || offset > length - 1) {
        return TDEOF;
    }
    return [string characterAtIndex:offset++];
}


- (void)unread {
    offset = (0 == offset) ? 0 : offset - 1;
}


- (void)unread:(NSUInteger)count {
    NSUInteger i = 0;
    for ( ; i < count - 1; i++) {
        [self unread];
    }
}

@synthesize offset;
@end
