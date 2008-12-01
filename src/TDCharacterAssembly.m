//
//  TDCharacterAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDCharacterAssembly.h>

@interface TDAssembly ()
@property (nonatomic, readwrite, copy) NSString *defaultDelimiter;
@end

@implementation TDCharacterAssembly

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super initWithString:s];
    if (self != nil) {
        self.defaultDelimiter = @"";
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    TDCharacterAssembly *a = (TDCharacterAssembly *)[super copyWithZone:zone];
    return a;
}


- (id)peek {
    if (index >= string.length) {
        return nil;
    }
    NSInteger c = [string characterAtIndex:index];
    return [NSNumber numberWithInteger:c];
}


- (id)next {
    id obj = [self peek];
    if (obj) {
        index++;
    }
    return obj;
}


- (BOOL)hasMore {
    return (index < string.length);
}


- (NSInteger)length {
    return string.length;
} 


- (NSInteger)objectsConsumed {
    return index;
}


- (NSInteger)objectsRemaining {
    return (string.length - index);
}


- (NSString *)consumedObjectsSeparatedBy:(NSString *)delimiter {
    NSInteger len = self.objectsConsumed;
    return [string substringToIndex:len];
}


- (NSString *)remainingObjectsSeparatedBy:(NSString *)delimiter {
    NSInteger len = self.objectsConsumed;
    return [string substringFromIndex:len];
}


// overriding simply to print NSNumber objects as their unichar values
- (NSString *)description {
    NSMutableString *s = [NSMutableString string];
    [s appendString:@"["];
    
    NSInteger i = 0;
    NSInteger len = stack.count;
    
    for (id obj in self.stack) {
        if ([obj isKindOfClass:[NSNumber class]]) { // ***this is needed for Char Assemblies
            [s appendFormat:@"%C", [obj integerValue]];
        } else {
            [s appendString:[obj description]];
        }
        if (i != len - 1) {
            [s appendString:@", "];
        }
        i++;
    }
    
    [s appendString:@"]"];
    
    [s appendString:[self consumedObjectsSeparatedBy:self.defaultDelimiter]];
    [s appendString:@"^"];
    [s appendString:[self remainingObjectsSeparatedBy:self.defaultDelimiter]];
    
    return [[s copy] autorelease];
}

@end
