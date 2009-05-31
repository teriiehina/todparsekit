//
//  XPathAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPathContext;
@class TDReader;

@interface XPathAssembler : NSObject {
    XPathContext *context;
}
- (void)resetWithReader:(TDReader *)r;
@property (retain) XPathContext *context;
@end
