//
//  TDSimpleCSSAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/23/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;

@interface TDSimpleCSSAssembler : NSObject {
    NSMutableDictionary *properties;
    TDToken *paren;
    TDToken *curly;
}
@property (nonatomic, retain) NSMutableDictionary *properties;
@property (nonatomic, retain) TDToken *paren;
@property (nonatomic, retain) TDToken *curly;
@end
