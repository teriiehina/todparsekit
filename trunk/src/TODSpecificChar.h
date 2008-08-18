//
//  TODSpecificChar.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTerminal.h"

@interface TODSpecificChar : TODTerminal {
}
+ (id)specificCharWithChar:(NSInteger)c;
- (id)initWithSpecificChar:(NSInteger)c;
@end
