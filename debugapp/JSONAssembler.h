//
//  JSONAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONAssembler : NSObject {
    id defaultAttrs;
    id objectAttrs;
    id arrayAttrs;
    id propertyNameAttrs;
    id valueAttrs;
    id constantAttrs;
}
@property (retain) id defaultAttrs;
@property (retain) id objectAttrs;
@property (retain) id arrayAttrs;
@property (retain) id propertyNameAttrs;
@property (retain) id valueAttrs;
@property (retain) id constantAttrs;
@end
