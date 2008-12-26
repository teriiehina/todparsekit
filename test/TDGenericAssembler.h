//
//  TDGenericAssembler.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/22/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDGenericAssembler : NSObject {
    NSMutableDictionary *attributes;
    NSMutableDictionary *defaultProperties;
    NSMutableAttributedString *displayString;
}
@property (nonatomic, retain) NSMutableDictionary *attributes;
@property (nonatomic, retain) NSMutableDictionary *defaultProperties;
@property (nonatomic, copy) NSMutableAttributedString *displayString;
@end
