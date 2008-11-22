//
//  XPathAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPathContext;

@interface XPathAssembler : NSObject {
    XPathContext *context;
}
- (void)reset;
@property (retain) XPathContext *context;
@end
