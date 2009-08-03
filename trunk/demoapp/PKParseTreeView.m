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
- (void)drawNode:(PKParseTree *)n atPoint:(NSPoint)p;
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
        [self drawNode:parseTree atPoint:NSMakePoint(NSMidX(r), NSMinY(r) + PADDING)];
    }
}

                                                     
- (void)drawNode:(PKParseTree *)n atPoint:(NSPoint)p {
    NSString *label = [self labelFromNode:n];
    NSSize boxSize = [label sizeWithAttributes:labelAttrs];
    NSRect textBox = NSMakeRect(p.x - PKHalfWidth(boxSize), p.y, boxSize.width, boxSize.height);
    NSRect box = NSUnionRect(NSOffsetRect(textBox, -HALF_PADDING, -HALF_PADDING), NSOffsetRect(textBox, HALF_PADDING, HALF_PADDING));
    [[NSColor blackColor] set];
    NSFrameRect(box);
    [label drawInRect:textBox withAttributes:labelAttrs];
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
