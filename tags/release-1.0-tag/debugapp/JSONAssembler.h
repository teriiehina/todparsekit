//
//  JSONAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;

@interface JSONAssembler : NSObject {
    NSMutableAttributedString *displayString;
    id defaultAttrs;
    id objectAttrs;
    id arrayAttrs;
    id propertyNameAttrs;
    id valueAttrs;
    id constantAttrs;
    
    TDToken *comma;
    TDToken *curly;
    TDToken *bracket;
}
@property (retain) NSMutableAttributedString *displayString;
@property (retain) id defaultAttrs;
@property (retain) id objectAttrs;
@property (retain) id arrayAttrs;
@property (retain) id propertyNameAttrs;
@property (retain) id valueAttrs;
@property (retain) id constantAttrs;
@property (retain) TDToken *comma;
@property (retain) TDToken *curly;
@property (retain) TDToken *bracket;
@end
