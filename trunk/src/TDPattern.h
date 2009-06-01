//
//  TDPattern.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

@interface TDPattern : TDTerminal {

}

+ (id)patternWithString:(NSString *)s;
@end
