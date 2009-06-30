//
//  TDLiteral.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDLiteral.h>
#import <ParseKit/TDToken.h>

@interface TDLiteral ()
@property (nonatomic, retain) TDToken *literal;
@end

@implementation TDLiteral

+ (id)literalWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
    //NSParameterAssert(s);
    self = [super initWithString:s];
    if (self) {
        self.literal = [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:s floatValue:0.0];
    }
    return self;
}


- (void)dealloc {
    self.literal = nil;
    [super dealloc];
}


- (BOOL)qualifies:(id)obj {
    return [literal.stringValue isEqualToString:[obj stringValue]];
    //return [literal isEqual:obj];
}


- (NSString *)description {
    NSString *className = [[self className] substringFromIndex:2];
    if (name.length) {
        return [NSString stringWithFormat:@"%@ (%@) %@", className, name, literal.stringValue];
    } else {
        return [NSString stringWithFormat:@"%@ %@", className, literal.stringValue];
    }
}

@synthesize literal;
@end
