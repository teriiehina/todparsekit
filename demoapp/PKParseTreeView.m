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
#define ROW_HEIGHT 40.0
#define CELL_WIDTH 100.0

static inline CGFloat PKHalfWidth(NSSize s) {
    return s.width / 2.0;
}

@interface PKParseTreeView ()
- (void)drawChildrenOf:(PKParseTree *)parent;
- (void)drawNode:(PKParseTree *)n ;

- (CGFloat)processChildrenOf:(PKParseTree *)parent centeredAt:(NSPoint)p;
- (CGFloat)processNode:(PKParseTree *)n centeredAt:(NSPoint)p;

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
        PKParseTree *tr = [PKParseTree parseTree];
        [tr addChild:parseTree];

        [self processChildrenOf:tr centeredAt:NSMakePoint(NSMidX(r), NSMinY(r) + PADDING)];
        [self drawChildrenOf:tr];
    }
}


- (void)drawChildrenOf:(PKParseTree *)parent {
    for (PKParseTree *n in [parent children]) {
        [self drawNode:n];
        [self drawChildrenOf:n];
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


- (CGFloat)processChildrenOf:(PKParseTree *)parent centeredAt:(NSPoint)p {
    CGFloat w = 0.0;
    for (PKParseTree *n in [parent children]) {
        w += [self processNode:n centeredAt:p];
        p.y += ROW_HEIGHT;
        [self processChildrenOf:n centeredAt:p];
        p.y -= ROW_HEIGHT;
    }
    return w;
}


- (CGFloat)processNode:(PKParseTree *)n centeredAt:(NSPoint)p {
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
    return boxRect.size.width + PADDING * 2;
}


- (NSString *)labelFromNode:(PKParseTree *)n {
    if ([n isKindOfClass:[PKTokenNode class]]) {
        return [[(PKTokenNode *)n token] stringValue];
    } else if ([n isKindOfClass:[PKRuleNode class]]) {
        return [(PKRuleNode *)n name];
    } else {
        return @"root";
    }
}

@synthesize parseTree;
@synthesize labelAttrs;
@end
