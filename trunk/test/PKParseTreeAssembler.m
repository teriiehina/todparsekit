//
//  PKParseTreeAssembler.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKParseTreeAssembler.h"
#import <ParseKit/ParseKit.h>

static const char *sPrefix = "workOn";
static const NSInteger sPrefixLen = 6;

@interface PKParseTreeAssembler ()
- (BOOL)isAssemblerSelector:(SEL)sel;
- (NSString *)productionNameFromSelector:(SEL)sel;
- (void)workOnProductionNamed:(NSString *)name assembly:(PKAssembly *)a;
@end

@implementation PKParseTreeAssembler

- (BOOL)isAssemblerSelector:(SEL)sel {
    char *s = (char *)sel;
    return strlen(s) > 7 && !strncmp(s, sPrefix, sPrefixLen);
}


- (NSString *)productionNameFromSelector:(SEL)sel {
    NSString *name = NSStringFromSelector(sel);
    name = [name substringWithRange:NSMakeRange(sPrefixLen, [name length] - (sPrefixLen + 1))];
    name = [NSString stringWithFormat:@"%C%@", tolower([name characterAtIndex:0]), [name substringFromIndex:1]];
    return name;
}


- (BOOL)respondsToSelector:(SEL)sel {
    if ([super respondsToSelector:sel]) {
        return YES;
    } else if ([self isAssemblerSelector:sel]) {
        return YES;
    }

    return NO;
}


//- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
//    if ([self isAssemblerSelector:sel]) {
//        return [NSObject instanceMethodSignatureForSelector:sel];
//    } else {
//        return [super methodSignatureForSelector:sel];
//    }
//}


- (void)forwardInvocation:(NSInvocation *)invoc {
    SEL sel = [invoc selector];
    
    if ([self isAssemblerSelector:sel]) {
        PKAssembly *a = nil;
        [invoc getArgument:a atIndex:0];
        [self workOnProductionNamed:[self productionNameFromSelector:sel] assembly:a];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}


- (void)workOnProductionNamed:(NSString *)name assembly:(PKAssembly *)a {
    
}

@end
