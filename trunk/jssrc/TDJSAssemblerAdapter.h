//
//  TDJSAssemblerAdapter.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class TDAssembly;

@interface TDJSAssemblerAdapter : NSObject {
    JSContextRef ctx;
    JSObjectRef assemblerFunction;
}
- (void)workOnAssembly:(TDAssembly *)a;

- (JSObjectRef)assemblerFunction;
- (void)setAssemblerFunction:(JSObjectRef)f fromContext:(JSContextRef)c;
@end
