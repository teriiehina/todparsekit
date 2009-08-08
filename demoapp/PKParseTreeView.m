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
#define ROW_HEIGHT 50.0
#define CELL_WIDTH 100.0

static inline CGFloat PKHalfWidth(NSSize s) {
    return s.width / 2.0;
}

@interface PKParseTreeView ()
- (void)drawTree:(PKParseTree *)n atPoint:(CGPoint)p;
- (void)drawParentNode:(PKParseTree *)n atPoint:(CGPoint)p;
- (void)drawLeafNode:(PKTokenNode *)n atPoint:(CGPoint)p;
- (NSString *)labelFromNode:(PKParseTree *)n;
- (void)drawLabel:(NSString *)label atPoint:(CGPoint)p;
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


- (void)drawParseTree:(PKParseTree *)t {
    self.parseTree = t;
    
    CGFloat w = [t width] * 100;
    CGFloat h = [t depth] * ROW_HEIGHT + 120;
    NSRect r = NSMakeRect(0, 0, w, h);
    if (NSContainsRect([[self superview] bounds], r)) {
        r = [[self superview] bounds];
    }
    [self setFrameSize:r.size];
    
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)r {
    [[NSColor whiteColor] set];
    NSRectFill(r);
    
    [self drawTree:parseTree atPoint:CGPointMake(r.size.width / 2, 20)];
}


- (void)drawTree:(PKParseTree *)n atPoint:(CGPoint)p {
    if ([n isKindOfClass:[PKTokenNode class]]) {
        [self drawLeafNode:(id)n atPoint:p];
    } else {
        [self drawParentNode:n atPoint:p];
    }
}


- (void)drawParentNode:(PKParseTree *)n atPoint:(CGPoint)p {
    NSUInteger i = 0;
    NSUInteger c = [[n children] count];

    CGFloat widths[c];
    CGFloat totalWidth = 0;
    for (PKParseTree *child in [n children]) {
        widths[i] = [child width] * 100;
        totalWidth += widths[i++];
    }
    
    CGFloat exes[c];
    if (1 == c) {
        exes[0] = p.x;
    } else {
        for (i = 0; i < c; i++) {
            if (i < c / 2) {
                exes[i] = p.x - totalWidth / c;
            } else {
                exes[i] = p.x + totalWidth / c;
            }
        }
    }
    
    [self drawLabel:[self labelFromNode:n] atPoint:CGPointMake(p.x, p.y)];
    
    
    // draw children
    CGPoint points[c];
    i = 0;
    if (1 == c) {
        points[i] = CGPointMake(exes[0], p.y + ROW_HEIGHT);
        [self drawTree:[[n children] objectAtIndex:0] atPoint:points[i]];
    } else {
        for (PKParseTree *child in [n children]) {
            if (i == c / 2) {
                points[i] = CGPointMake(p.x, p.y + ROW_HEIGHT);
            } else if (i < c / 2) {
                points[i] = CGPointMake(exes[i] + widths[i]/2, p.y + ROW_HEIGHT);
            } else {
                points[i] = CGPointMake(exes[i] - widths[i]/2, p.y + ROW_HEIGHT);
            }
            [self drawTree:child atPoint:points[i++]];
        }
    }


    // draw lines
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    for (i = 0; i < c; i++) {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, p.x, p.y + 15);
        CGContextAddLineToPoint(ctx, points[i].x, points[i].y - 4);
        CGContextStrokePath(ctx);
        CGContextClosePath(ctx);
    }
}


- (void)drawLeafNode:(PKTokenNode *)n atPoint:(CGPoint)p {
    [self drawLabel:[self labelFromNode:n] atPoint:CGPointMake(p.x, p.y)];
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


- (void)drawLabel:(NSString *)label atPoint:(CGPoint)p {
    NSSize s = [label sizeWithAttributes:labelAttrs];
    p.x -= s.width / 2;
    [label drawAtPoint:NSPointFromCGPoint(p) withAttributes:labelAttrs];
}

@synthesize parseTree;
@synthesize labelAttrs;
@end



//- (void)drawNode:(PKParseTree *)n {
//    NSRect boxRect = [[[n userInfo] objectForKey:@"boxRect"] rectValue];
//    [[NSColor blackColor] set];
//    NSFrameRect(boxRect);
//    
//    NSString *label = [[n userInfo] objectForKey:@"label"];
//    NSRect labelRect = [[[n userInfo] objectForKey:@"labelRect"] rectValue];
//    [label drawInRect:labelRect withAttributes:labelAttrs];
//}

