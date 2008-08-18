//
//  TODWord.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TODParseKit/TODTerminal.h>

@interface TODWord : TODTerminal {

}
+ (id)word;
+ (id)wordWithString:(NSString *)s;
@end
