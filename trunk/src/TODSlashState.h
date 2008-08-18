//
//  TODSlashState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TODParseKit/TODTokenizerState.h>

@class TODSlashSlashState;
@class TODSlashStarState;

@interface TODSlashState : TODTokenizerState {
	TODSlashSlashState *slashSlashState;
	TODSlashStarState *slashStarState;
}
@end
