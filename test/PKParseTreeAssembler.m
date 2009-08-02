//
//  PKParseTreeAssembler.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKParseTreeAssembler.h"
#import "PKParseTree.h"
#import "PKRuleNode.h"
#import "PKTokenNode.h"
#import <ParseKit/ParseKit.h>

@interface PKParseTreeAssembler ()
- (NSString *)ruleNameForSelName:(NSString *)selName withPrefix:(NSString *)pre;
- (void)workOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a;
- (void)beforeWorkOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a;
- (void)workOnToken:(PKAssembly *)a;
- (PKParseTree *)currentFrom:(PKAssembly *)a;

@property (nonatomic, retain) NSMutableDictionary *ruleNames;
@property (nonatomic, copy) NSString *assemblerPrefix;
@property (nonatomic, copy) NSString *preassemblerPrefix;
@property (nonatomic, copy) NSString *suffix;
@end

@implementation PKParseTreeAssembler

- (id)init {
    if (self = [super init]) {
        self.ruleNames = [NSMutableDictionary dictionary];
        self.assemblerPrefix = @"workOn";
        self.preassemblerPrefix = @"beforeWorkOn";
        self.suffix = @":";
    }
    return self;
}


- (void)dealloc {
    self.assemblerPrefix = nil;
    self.preassemblerPrefix = nil;
    self.suffix = nil;
    [super dealloc];
}


- (BOOL)respondsToSelector:(SEL)sel {
    return YES;
    if ([super respondsToSelector:sel]) {
        return YES;
    } else {
        NSString *selName = NSStringFromSelector(sel);
        if ([selName hasPrefix:assemblerPrefix] && [selName hasSuffix:suffix]) {
            return YES;
        }
    }
    return NO;
}


- (id)performSelector:(SEL)sel withObject:(id)obj {
    NSString *selName = NSStringFromSelector(sel);
    
    if ([selName hasPrefix:assemblerPrefix] && [selName hasSuffix:suffix]) {
        [self workOnRuleNamed:[self ruleNameForSelName:selName withPrefix:assemblerPrefix] withAssembly:obj];
    } else if ([selName hasPrefix:preassemblerPrefix] && [selName hasSuffix:suffix]) {
        [self beforeWorkOnRuleNamed:[self ruleNameForSelName:selName withPrefix:preassemblerPrefix] withAssembly:obj];
    } else if ([super respondsToSelector:sel]) {
        return [super performSelector:sel withObject:obj];
    } else {
        NSAssert(0, @"");
    }
    return nil;
}

- (NSString *)ruleNameForSelName:(NSString *)selName withPrefix:(NSString *)pre {
    NSString *ruleName = [ruleNames objectForKey:selName];
    
    if (!ruleName) {
        NSUInteger prefixLen = pre.length;
        NSInteger c = ((NSInteger)[selName characterAtIndex:prefixLen]) + 32; // lowercase
        NSRange r = NSMakeRange(prefixLen + 1, selName.length - (prefixLen + suffix.length + 1 /*:*/));
        ruleName = [NSString stringWithFormat:@"%C%@", c, [selName substringWithRange:r]];
        [ruleNames setObject:ruleName forKey:selName];
    }
    
    return ruleName;
}


- (void)beforeWorkOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a {
    PKParseTree *current = [self currentFrom:a];
    [self workOnToken:a];
    current = [current addChildRule:name];
    a.target = current;
}


- (void)workOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a {
    [self workOnToken:a];
    PKParseTree *current = [self currentFrom:a];
    a.target = current.parent;
    current = current.parent;
}


- (PKParseTree *)currentFrom:(PKAssembly *)a {
    PKParseTree *current = a.target;
    if (!current) {
        current = [PKParseTree parseTree];
        a.target = current;
    }
    return current;
}


- (void)workOnToken:(PKAssembly *)a {
    if (![a isStackEmpty]) {
        id tok = [a pop];
        NSAssert([tok isKindOfClass:[PKToken class]], @"");
        [[self currentFrom:a] addChildToken:tok];
    }
}

@synthesize ruleNames;
@synthesize assemblerPrefix;
@synthesize preassemblerPrefix;
@synthesize suffix;
@end
