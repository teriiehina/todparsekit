//
//  PKParseTreeView.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKParseTreeView.h"
#import <ParseKit/ParseKit.h>

#define PADDING 6.0
#define HALF_PADDING PADDING / 2.0

static inline CGFloat PKHalfWidth(NSSize s) {
    return s.width / 2.0;
}

@interface PKParseTreeView ()
- (void)drawNode:(PKParseTree *)n ;
- (void)preprocessNode:(PKParseTree *)n centeredAt:(NSPoint)p;
- (NSString *)labelFromNode:(PKParseTree *)n;
@end

@implementation PKParseTreeView

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.labelAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSFont boldSystemFontOfSize:10], NSFontAttributeName,
                           [NSColor blackColor], NSForegroundColorAttributeName,
                           nil];
        
    }
    return self;
}

- (void)dealloc {
    self.parseTree = nil;
    self.labelAttrs = nil;
    [super dealloc];
}


- (BOOL)isFlipped {
    return YES;
}


- (void)drawRect:(NSRect)r {
    [[NSColor whiteColor] set];
    NSRectFill(r);
    
    
    if (parseTree) {
        [self preprocessNode:parseTree centeredAt:NSMakePoint(NSMidX(r), NSMinY(r) + PADDING)];
        [self drawNode:parseTree];
    }
}

                                                     
- (void)drawNode:(PKParseTree *)n {
    NSRect boxRect = [[[n userInfo] objectForKey:@"boxRect"] rectValue];
    [[NSColor blackColor] set];
    NSFrameRect(boxRect);

    NSString *label = [[n userInfo] objectForKey:@"label"];
    NSRect labelRect = [[[n userInfo] objectForKey:@"labelRect"] rectValue];
    [label drawInRect:labelRect withAttributes:labelAttrs];
}


- (void)preprocessNode:(PKParseTree *)n centeredAt:(NSPoint)p {
    NSString *label = [self labelFromNode:n];
    NSSize labelSize = [label sizeWithAttributes:labelAttrs];
    if (labelSize.width > 100) {
        labelSize.width = 100;
    }
    NSRect labelRect = NSMakeRect(p.x - PKHalfWidth(labelSize), p.y, labelSize.width, labelSize.height);
    NSRect boxRect = NSUnionRect(NSOffsetRect(labelRect, -HALF_PADDING, -HALF_PADDING), NSOffsetRect(labelRect, HALF_PADDING, HALF_PADDING));

    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [n setUserInfo:d];
    [d setObject:label forKey:@"label"];
    [d setObject:[NSValue valueWithRect:labelRect] forKey:@"labelRect"];
    [d setObject:[NSValue valueWithRect:boxRect] forKey:@"boxRect"];
}


- (NSString *)labelFromNode:(PKParseTree *)n {
    if ([n isKindOfClass:[PKParseTree class]]) {
        return @"root";
    } else if ([n isKindOfClass:[PKRuleNode class]]) {
        return [(PKRuleNode *)n name];
    } else {
        return [[(PKTokenNode *)n token] stringValue];
    }
}

@synthesize parseTree;
@synthesize labelAttrs;
@end
