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
- (void)didMatchRuleNamed:(NSString *)name assembly:(PKAssembly *)a;
- (void)willMatchRuleNamed:(NSString *)name assembly:(PKAssembly *)a;
- (void)didMatchToken:(PKAssembly *)a;
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
        self.preassemblerPrefix = @"willMatch";
        self.assemblerPrefix = @"didMatch";
        self.suffix = @":";
    }
    return self;
}


- (void)dealloc {
    self.preassemblerPrefix = nil;
    self.assemblerPrefix = nil;
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
        [self didMatchRuleNamed:[self ruleNameForSelName:selName withPrefix:assemblerPrefix] assembly:obj];
    } else if ([selName hasPrefix:preassemblerPrefix] && [selName hasSuffix:suffix]) {
        [self willMatchRuleNamed:[self ruleNameForSelName:selName withPrefix:preassemblerPrefix] assembly:obj];
    } else if ([super respondsToSelector:sel]) {
        return [super performSelector:sel withObject:obj];
    } else {
        NSAssert(0, @"");
    }
    return nil;
}


- (NSString *)ruleNameForSelName:(NSString *)selName withPrefix:(NSString *)prefix {
    NSString *ruleName = [ruleNames objectForKey:selName];
    
    if (!ruleName) {
        NSUInteger prefixLen = prefix.length;
        NSInteger c = ((NSInteger)[selName characterAtIndex:prefixLen]) + 32; // lowercase
        NSRange r = NSMakeRange(prefixLen + 1, selName.length - (prefixLen + suffix.length + 1 /*:*/));
        ruleName = [NSString stringWithFormat:@"%C%@", c, [selName substringWithRange:r]];
        [ruleNames setObject:ruleName forKey:selName];
    }
    
    return ruleName;
}


- (void)willMatchRuleNamed:(NSString *)name assembly:(PKAssembly *)a {
    PKParseTree *current = [self currentFrom:a];
    [self didMatchToken:a];
    current = [current addChildRule:name];
    a.target = current;
}


- (void)didMatchRuleNamed:(NSString *)name assembly:(PKAssembly *)a {
    [self didMatchToken:a];
    PKParseTree *current = [self currentFrom:a];
    a.target = current.parent;
}


- (PKParseTree *)currentFrom:(PKAssembly *)a {
    PKParseTree *current = a.target;
    if (!current) {
        current = [PKParseTree parseTree];
        a.target = current;
    }
    return current;
}


- (void)didMatchToken:(PKAssembly *)a {
    if (![a isStackEmpty]) {
        id tok = [a pop];
        NSAssert([tok isKindOfClass:[PKToken class]], @"");
        [[self currentFrom:a] addChildToken:tok];
    }
}

@synthesize ruleNames;
@synthesize preassemblerPrefix;
@synthesize assemblerPrefix;
@synthesize suffix;
@end
