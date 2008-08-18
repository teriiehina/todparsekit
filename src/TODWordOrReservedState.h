//
//  TODWordOrReservedState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODWordState.h"

@interface TODWordOrReservedState : TODWordState {
	NSMutableSet *reservedWords;
}
- (void)addReservedWord:(NSString *)s;
@end
