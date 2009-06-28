//
//  TDAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAssembly.h>

static NSString * const TDAssemblyDefaultDelimiter = @"/";

@interface TDAssembly ()
@property (nonatomic, readwrite, retain) NSMutableArray *stack;
@property (nonatomic) NSUInteger index;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, readwrite, retain) NSString *defaultDelimiter;
@end

@implementation TDAssembly

+ (id)assemblyWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    if (self = [super init]) {
        self.stack = [NSMutableArray array];
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.stack = nil;
    self.string = nil;
    self.target = nil;
    self.defaultDelimiter = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    // use of NSAllocateObject() below is a *massive* optimization over calling the designated initializer -initWithString: here.
    // this line (and this method in general) is *vital* to the overall performance of the framework. dont fuck with it.
    TDAssembly *a = NSAllocateObject([self class], 0, zone);
    a->stack = [stack mutableCopyWithZone:zone];
    a->string = [string retain];
    if (defaultDelimiter) {
        a->defaultDelimiter = [defaultDelimiter retain];
    }
    if (target) {
        a->target = [target mutableCopyWithZone:zone];
    }
    a->index = index;
    return a;
}


- (BOOL)isEqual:(id)obj {
    if (![obj isMemberOfClass:[self class]]) {
        return NO;
    }
    
    TDAssembly *a = (TDAssembly *)obj;
    if (a.length != self.length) {
        return NO;
    }

    if (a->index != index) {
        return NO;
    }
    
    if (a.stack.count != stack.count) {
        return NO;
    }
    
    return [[self description] isEqualToString:[obj description]];
}


- (id)next {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}


- (BOOL)hasMore {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return NO;
}


- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}


- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}


- (NSUInteger)length {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}


- (NSUInteger)objectsConsumed {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}


- (NSUInteger)objectsRemaining {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}


- (id)peek {
    NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}


- (id)pop {
    id result = nil;
    if (stack.count) {
        result = [[[stack lastObject] retain] autorelease];
        [stack removeLastObject];
    }
    return result;
}


- (void)push:(id)object {
    if (object) {
        [stack addObject:object];
    }
}


- (BOOL)isStackEmpty {
    return 0 == stack.count;
}


- (NSArray *)objectsAbove:(id)fence {
    NSMutableArray *result = [NSMutableArray array];
    
    while (stack.count) {        
        id obj = [self pop];
        
        if ([obj isEqual:fence]) {
            [self push:obj];
            break;
        } else {
            [result addObject:obj];
        }
    }
    
    return result;
}


- (NSString *)description {
    NSMutableString *s = [NSMutableString string];
    [s appendString:@"["];
    
    NSUInteger i = 0;
    NSUInteger len = stack.count;
    
    for (id obj in stack) {
        [s appendString:[obj description]];
        if (len - 1 != i++) {
            [s appendString:@", "];
        }
    }
    
    [s appendString:@"]"];
    
    NSString *d = defaultDelimiter ? defaultDelimiter : TDAssemblyDefaultDelimiter;
    [s appendString:[self consumedObjectsJoinedByString:d]];
    [s appendString:@"^"];
    [s appendString:[self remainingObjectsJoinedByString:d]];
    
    return [[s copy] autorelease];
}

@synthesize stack;
@synthesize target;
@synthesize index;
@synthesize string;
@synthesize defaultDelimiter;
@end
