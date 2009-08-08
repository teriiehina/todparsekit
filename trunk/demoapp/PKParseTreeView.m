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
- (void)drawTree:(PKParseTree *)n atPoint:(NSPoint)p;
- (void)drawParentNode:(PKParseTree *)n atPoint:(NSPoint)p;
- (void)drawLeafNode:(PKTokenNode *)n atPoint:(NSPoint)p;
- (NSString *)labelFromNode:(PKParseTree *)n;
- (void)drawLabel:(NSString *)label atPoint:(NSPoint)p;
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
    CGFloat h = [t depth] * 100 + 120;
    [self setFrameSize:NSMakeSize(w, h)];
    
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)r {
    [[NSColor whiteColor] set];
    NSRectFill(r);
    
    [self drawTree:parseTree atPoint:NSMakePoint(r.size.width / 2, 20)];
}


- (void)drawTree:(PKParseTree *)n atPoint:(NSPoint)p {
    if ([n isKindOfClass:[PKTokenNode class]]) {
        [self drawLeafNode:(id)n atPoint:p];
    } else {
        [self drawParentNode:n atPoint:p];
    }
}


- (void)drawParentNode:(PKParseTree *)n atPoint:(NSPoint)p {
    NSUInteger i = 0;
    NSUInteger c = [[n children] count];

    CGFloat widths[c];
    CGFloat totalWidth = 0;
    for (PKParseTree *child in [n children]) {
        widths[i] = [child width] * 100;
        totalWidth += widths[i++];
    }
    
    CGFloat exes[c];
    for (i = 0; i < c; i++) {
        if (i < c / 2) {
            exes[i] = p.x - totalWidth / c;
        } else {
            exes[i] = p.x + totalWidth / c;
        }
    }
    
    [self drawLabel:[self labelFromNode:n] atPoint:NSMakePoint(p.x - 20, p.y - 10)];
    
    // draw lines
    //CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
    
    // draw children
    
    i = 0;
    for (PKParseTree *child in [n children]) {
        if (i < c / 2) {
            [self drawTree:child atPoint:NSMakePoint(exes[i] + widths[i]/2, p.y + 100)];
        } else {
            [self drawTree:child atPoint:NSMakePoint(exes[i] - widths[i]/2, p.y + 100)];
        }
        i++;
    }
}


- (void)drawLeafNode:(PKTokenNode *)n atPoint:(NSPoint)p {
    [self drawLabel:[self labelFromNode:n] atPoint:NSMakePoint(p.x - 20, p.y)];
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


- (void)drawLabel:(NSString *)label atPoint:(NSPoint)p {
    [label drawAtPoint:p withAttributes:labelAttrs];
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

