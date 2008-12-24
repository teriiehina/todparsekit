//
//  TDSimpleCSSAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/23/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSimpleCSSAssembler : NSObject {
    NSMutableDictionary *properties;
}
@property (nonatomic, retain) NSMutableDictionary *properties;
@end
