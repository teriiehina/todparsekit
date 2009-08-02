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
- (NSString *)ruleNameForSelName:(NSString *)selName;
- (void)workOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a;

@property (nonatomic, retain, readwrite) PKParseTree *rootNode;
//@property (nonatomic, assign, readwrite) PKParseTree *currentNode;

@property (nonatomic, retain) NSMutableDictionary *ruleNames;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *suffix;
@end

@implementation PKParseTreeAssembler

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[PKParseTree alloc] init] autorelease];
//        self.currentNode = rootNode;

        self.ruleNames = [NSMutableDictionary dictionary];
        self.prefix = @"workOn";
        self.suffix = @":";
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
//    currentNode = nil;
    self.prefix = nil;
    self.suffix = nil;
    [super dealloc];
}


//- (void)workOnRule:(PKAssembly *)a {
//    id name = [a pop];
//    NSAssert([name isKindOfClass:[NSString class]], @"");
//    PKRuleNode *n = [currentNode addChildRule:name];
//    self.currentNode = n;
//}
//
//
//- (void)workOnToken:(PKAssembly *)a {
//    id tok = [a pop];
//    NSAssert([tok isKindOfClass:[PKToken class]], @"");
//    [currentNode addChildToken:tok];
//}


- (BOOL)respondsToSelector:(SEL)sel {
    return YES;
    if ([super respondsToSelector:sel]) {
        return YES;
    } else {
        NSString *selName = NSStringFromSelector(sel);
        if ([selName hasPrefix:prefix] && [selName hasSuffix:suffix]) {
            return YES;
        }
    }
    return NO;
}


- (id)performSelector:(SEL)sel withObject:(id)obj {
    NSString *selName = NSStringFromSelector(sel);
    
    if (![selName hasPrefix:prefix] || ![selName hasSuffix:suffix]) {
        if ([super respondsToSelector:sel]) {
            return [super performSelector:sel withObject:obj];
        } else {
            NSAssert(0, @"");
            return nil;
        }
    }
    
    [self workOnRuleNamed:[self ruleNameForSelName:selName] withAssembly:obj];
    return nil;
}


- (NSString *)ruleNameForSelName:(NSString *)selName {
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


- (void)workOnRuleNamed:(NSString *)name withAssembly:(PKAssembly *)a {
    NSLog(@"%@", a);

    PKParseTree *current = a.target;
    if (!current) {
        current = [PKParseTree parseTree];
        a.target = current;
    }

    id obj = [a pop];
    if ([obj isKindOfClass:[PKToken class]]) {
        PKRuleNode *ruleNode = [current addChildRule:name];
        [ruleNode addChildToken:obj];
    } else {
        
    }

    NSLog(@"%@", current);
}

@synthesize rootNode;
//@synthesize currentNode;
@synthesize ruleNames;
@synthesize prefix;
@synthesize suffix;
@end
